# TP Système de sauvegarde
Réaliser par Maxime COHEN - I4 - EPSI

## Sujet
Vous devez mettre en place la sauvegarde de cette application de la manière la plus efficace possible en
considérant que le volume de données peut devenir très important.

De plus, vous devrez permettre une historisation de ces sauvegardes avec une durée de rétention de 30 jours.
Vous sauvegarderez bien évidemment les fichiers aussi bien que la base de données de manière à ce qu’une
restauration soit parfaitement possible.

Vous planifierez cette sauvegarde de manière à ce qu’elle s’effectue de manière totalement automatique, le
plus fréquemment possible et en mettent en application les bonnes pratiques étudiées en cours.

## Livraison

Le dépôt est constitué de deux script bash, `backup_save.sh` et `backup_restore.sh` qui doivent être déposés sur
le serveur de backup.

> Attention: Les scripts ne peuvent fonctionner que dans les machines virtuelles disponible dans le sujet.
Pour plus de détails, veuillez consulter le pdf `Sujet.pdf`.

### Installation

Après avoir cloné le dépôt sur le serveur `Backup`, il faut donner les droits d'exécution aux scripts.

```bash
chmod +x backup_save.sh backup_restore.sh
``` 
