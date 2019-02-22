#!/bin/bash

MYSQL_HOST='localhost'
MYSQL_USER='root'
MYSQL_PASS='root'
MYSQL_DBNAME='nextcloud'

programName=$(basename $0)
host=$1
port=$2

usage() {

    echo "usage: $programName [user@]hostname port"
    exit 1
}

save() {
    # Arrêt du service Nextcloud sur le serveur
    ssh -p $port $host "sudo -u www-data php /var/www/html/nextcloud/occ maintenance:mode --on"

    # Récupération des fichiers du serveur NextCloud
    rsync -Aavx -e "ssh -p $port" $host:/var/www/html/nextcloud/ /data/backup/nextcloud-dirbkp/

    # Récupération de la BDD du serveur NextCloud
    ssh -p $port $host "mysqldump --single-transaction -h $MYSQL_HOST -u $MYSQL_USER --password=$MYSQL_PASS $MYSQL_DBNAME" > /data/backup/nextcloud-sqlbkp.bak

    # Historisation du dossier backup
    zfs snapshot data/backup@nextcoud_`date +"%Y%m%d"`

    # Retention du nombre de snapshot (limité à 30)
    while [[ `zfs list -H -t snapshot -o name | wc -l` -gt 30 ]]; do
        zfs destroy `zfs list -H -t snapshot -o name | head -1`
    done

    # Redémarrage du service Nextcloud sur le serveur
    ssh -p $port $host "sudo -u www-data php /var/www/html/nextcloud/occ maintenance:mode --off"

    exit 0
}


if [[ $# == 0 ]] || [[ $1 == '-h' ]]; then
    usage
elif [[ $# -eq 2 ]]; then
    save
else
    echo "ERROR: Bad arguments"
    usage
fi