FILE=./InstallVars.sh  #file that will overwrite Variables for different computers. You can keep a copy for each computer in your house and reuse this script.
EDITOR=gedit  #Editor to be used for editting files

#============================ NAS and network variables =====================================
#bash for install NFS and other apps.  Ubuntu 23.04 based distros
SUBNET=""           #netwrok subnet of NAS
NAS=""              #host address for NAS Sever
PLEX=""             #host address for PLEX Server

#Flags for optionally installing required sections
iNAS=true
iPLEX=true

MOUNTPOINT="/mnt"  #every Linux machine will have this
FOLDERS=("test" "new")   #array for folder names

EDITOR=gedit  #Editor to be used for editting files

#============================ Programming Apps variables =====================================
#Some extensions don't work with the linux version of CODE
iVSCODE=false
VSCODE=https://packages.microsoft.com/repos/vscode/pool/main/c/code/  #URL where the VS Code files are
ffVSCODE=$(curl $VSCODE | grep -o -E 'code.+deb\"' | tail -1)  #GREP the last/latest deb file. There is an extra "
fVSCODE=${ffVSCODE::-1} #remove the last character


#============================ File to called to overwrite variables for individual machines =====================================
if test -f "$FILE"; then  #check if file exists
    echo "====================== Opening $FILE ========================"
    source $FILE ; fi  #run the other files

echo " ==================== Getting NFS Network and Folders variables  ========================"
#Network section.  Fill in the values 
if [$SUBNET -z ] ; then
    echo "Enter your subnet. Example: 192.168.0"
    read SUBNET ; fi

if [$NAS -z ] && $iNAS; then
    echo "Enter host address for the NAS server.  Example 100" 
    read NAS ; fi

if [$PLEX -z ] && $iPLEX  ; then
    echo "Enter host address for the PLEX server.  Example 100"
    read PLEX ; fi

#NFS Mount point
if [$MOUNTPOINT -z ] && $iNAS ; then
    echo "Enter the mount point for the NFS folders.  Example /mnt."
    read MOUNTPOINT ; fi



echo " ==================== Creating NFS folders  ========================"
echo $MOUNTPOINT && cd $MOUNTPOINT
if $iNAS ; then
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
    #sudo systemctl restart daemon-reload  
fi  #$iNAS

echo " ==================== DONE  ========================"

