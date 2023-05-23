FILE=./InstallVars.sh  #file that will override Variables for different computers

#bash for install NFS and other apps.  Ubuntu 23.04 based distros
SUBNET=""           #netwrok subnet of NAS
NAS=""              #host address for NAS Sever
PLEX=""             #host address for PLEX Server

MOUNTPOINT="/mnt"  #every Linux machine will have this
FOLDERS=("test" "new")   #array for folder names

EDITOR=gedit  #Editor to be used for editting files

if test -f "$FILE"; then  #check if file exists
    source $FILE ; fi

echo " ==================== Getting NFS Network and Folders variables  ========================"
#Network section.  Fill in the values 
if [$SUBNET -z ] ; then
    echo "Enter your subnet. Example: 192.168.0"
    read SUBNET ; fi

if [$NAS -z ] ; then
    echo "Enter host address for the NAS server.  Example 100" 
    read NAS ; fi

if [$PLEX -z ]  ; then
    echo "Enter host address for the PLEX server.  Example 100"
    read PLEX ; fi

#NFS Mount point
if [$MOUNTPOINT -z ] ; then
    echo "Enter the mount point for the NFS folders.  Example /mnt."
    read MOUNTPOINT ; fi



echo " ==================== Creating NFS folders  ========================"
echo $MOUNTPOINT && cd $MOUNTPOINT

if [ ${#FOLDERS[@]} -gt 0 ] ; then
    for f in ${FOLDERS[@]}; do
        mkdir $f ; done
else 
    echo "FOLDERS variable is empty" ; fi


#install the NFS package needed for the client side 
echo " ==================== NFS  ========================"
sudo apt install nfs-kernel-server -y
sudo apt install nfs-common -y

#check install and displays folders from NFS server
sudo showmount  -e $SUBNET"."$NAS

#edit files for mounting.
sudo $EDITOR /etc/hosts  #set host for NAS before the fstab.  

sudo $EDITOR /etc/fstab  #Use the NAS host in the FSTAB
sudo showmount -a
sudo systemctl daemon-reload



echo " ==================== DONE  ========================"

