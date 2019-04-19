#!/bin/bash

apt-get upgrade;
apt-get update;

echo "Installer les invite VB (insérer l'image avant si oui)? (O/n)"
read reponse;

if [ "$reponse" != "n" ]
then

	apt-get install -y build-essential module-assistant;
	m-a prepare -y;
	mount /media/cdrom;
	sh /media/cdrom/VBoxLinuxAdditions.run;
 
fi


apt-get install -y nfs;
apt-get install -y nfs-kernel-server;

#### Preparation du stockage FOG ###

bc = "no";
while [ "$bc" != "oui" ] && [ "$bc" != "o" ]  && [ "$bc" != "yes" ] && [ "$bc" != "y" ]
do 
   echo "Indiquez l'emplacement du dossier de stockage des images FOG sur ce serveur"
   read emplacement;
   echo "L'emplacement suivant est-il correcte? (o'\'n)"
   echo $emplacement;
   read bc;
done

mkdir "$emplacement" 2> /dev/null;
mkdir "$emplacement"/dev 2> /dev/null;
mkdir "$emplacement"/postdownloadscripts 2> /dev/null;

touch "$emplacement"/.mntcheck 2> /dev/null;
touch "$emplacement"/dev/.mntcheck 2> /dev/null;

chmod 777 -R "$emplacement"/;



#### Preparation de l'export NFS ###

echo $emplacement" *(ro,no_wdelay,no_subtree_check,insecure_locks,no_root_squash,insecure,sync,fsid=0,crossmnt)" >> /etc/exports ;

echo $emplacement"/dev *(rw,sync,no_wdelay,no_subtree_check,insecure_locks,no_root_squash,insecure,fsid=1,crossmnt)" >> /etc/exports ;

/etc/init.d/nfs-kernel-server start;

apt-get -y install proftpd;




