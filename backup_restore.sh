#!/bin/bash

MYSQL_HOST='localhost'
MYSQL_USER='root'
MYSQL_PASS='root'
MYSQL_DBNAME='nextcloud'

programName=$(basename $0)
host=$1
port=$2
snap=$3

usage() {

    echo "usage: $programName [user@]hostname port [snapshot_name]"
    exit 1
}

restore() {
    # Arrêt du service Nextcloud sur le serveur
    ssh -p $port $host "sudo -u www-data php /var/www/html/nextcloud/occ maintenance:mode --on"

    # Verrouillage de la snapshot
    zfs hold keep $1

    # Clone de la snapshot
    zfs clone $1 data/restore

    # Restauration des fichiers du serveur NextCloud
    rsync -Aavx /data/restore/nextcloud-dirbkp/ -e "ssh -p $port" $host:/var/www/html/nextcloud/

    # Nettoyage de la BDD avant restauration
    ssh -p $port $host  "mysql -h $MYSQL_HOST -u $MYSQL_USER --password=$MYSQL_PASS -e \"DROP DATABASE $MYSQL_DBNAME\""
    ssh -p $port $host  "mysql -h $MYSQL_HOST -u $MYSQL_USER --password=$MYSQL_PASS -e \"CREATE DATABASE $MYSQL_DBNAME\""

    # Restauration de la BDD du serveur NextCloud
    ssh -p $port $host  "mysql -h $MYSQL_HOST -u $MYSQL_USER --password=$MYSQL_PASS $MYSQL_DBNAME" < /data/restore/nextcloud-sqlbkp.bak

    # Suppression du clone de la snapshot
    zfs destroy data/restore

    # Déverrouillage de la snapshot
    zfs release keep $1

    # Redémarrage du service Nextcloud sur le serveur
    ssh -p $port $host "sudo -u www-data php /var/www/html/nextcloud/occ maintenance:mode --off"

    exit 0
}


if [[ $# == 0 ]] || [[ $1 == '-h' ]]; then
    usage
elif [[ $# -eq 2 ]]; then
    snap=`zfs list -H -t snapshot -o name -S creation | head -1`
    echo "Restoration of the last snapshot $snap"
    restore $snap
elif [[ $# -eq 3 ]]; then
    echo "Restoration of the snapshot $snap"
    restore $snap
else
    echo "ERROR: Bad arguments"
    usage
fi