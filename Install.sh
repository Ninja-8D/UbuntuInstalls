FILE=./InstallVars.sh  #file that will overwrite Variables for different computers. You can keep a copy for each computer in your house and reuse this script.
EDITOR=gedit  #Editor to be used for editting files

#sudo su -c "echo '#testing append with echo' >> /etc/fstab"

#============================ Nas and network variables =====================================
#bash for install NFS and other apps.  Ubuntu 23.04 based distros
SubNet=""           #netwrok SubNet of Nas
Nas=""              #host address for Nas Sever
Plex=""             #host address for Plex Server

#Flags for optionally installing required sections
iNas=true
iPlex=true
iGnomeExt=true

MountPoint="/media"  #every Linux machine will have this
Folders=("test" "new")   #array for folder names


#==================== VSCODE ==========================
iVSCODE=true #not Ready.  Files downloaded is not a debian structure file.  TODO:  Need to chown the VsCodeDeb file to not root.


#============================ File to called to overwrite variables for individual machines =====================================
if test -f "$FILE"; then  #check if file exists
    echo "====================== Opening $FILE ========================"
    source $FILE 
    fi  #run the other files



if $iGnomeExt ; then
   echo "sudo apt install gnome-shell-extension-manager"
   fi


   
echo " ==================== Getting NFS Network and Folders variables  ========================"
#Network section.  Fill in the values 
if [$SubNet -z ] ; then
    echo "Enter your SubNet. Example: 192.168.0"
    read SubNet 
    fi

if [$Nas -z ] && $iNas; then
    echo "Enter host address for the Nas server.  Example 100" 
    read Nas
    fi

if [$Plex -z ] && $iPlex  ; then
    echo "Enter host address for the Plex server.  Example 100"
    read Plex 
    fi

#NFS Mount point
if [$MountPoint -z ] && $iNas ; then
    echo "Enter the mount point for the NFS Folders.  Example /mnt."
    read MountPoint 
    fi



echo " ==================== Creating NFS Folders  ========================"
echo $MountPoint && cd $MountPoint
if $iNas && $Nas; then && $SubNet
    sudo su -c "echo $SubNet'.'$Nas' nas' >> /etc/hosts"  #setup hosts
    
if $iNas ; then
    if [ ${#Folders[@]} -gt 0 ] ; then
        for f in ${Folders[@]}; do
            mkdir $f ; done
    else 
        echo "Folders variable is empty" 
        fi
        
    #install the NFS package needed for the client side 
    echo " ==================== NFS  ========================"
    sudo apt install nfs-kernel-server -y
    sudo apt install nfs-common -y

    #check install and displays Folders from NFS server
    sudo showmount  -e $SubNet"."$Nas

    #edit files for mounting.
    sudo $EDITOR /etc/hosts  #set host for Nas before the fstab.  

    sudo $EDITOR /etc/fstab  #Use the Nas host in the FSTAB
    sudo showmount -a
    #sudo systemctl restart daemon-reload  
    fi  #$iNas
    
    

#============================ Programming Apps variables =====================================
#Some extensions don't work with the linux version of CODE
if $iVsCode; then
    cd ~/home/Downloads
    
    VsCodeDeb="VsCode.deb"
    VsCodeUrl="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"  
    echo -e "\n========== URL: "$VsCodeUrl" ======================\n"
    wget -O $VsCodeDeb $VsCodeUrl && sudo dpkg -i $VsCodeDeb
    fi
    
echo " ==================== DONE  ========================"
