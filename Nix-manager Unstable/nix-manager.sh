d=`date +%m:%d:%y:%H:%M:%S`

echo -e "\e[34mNix-manager revision 0.0.3 made by relogit. running as user '$USER'\e[0m"
echo -e "\e[1;36mPlease ensure the 'git' package is added to your configuration.nix.\e[0m"
if grep -q nix-manager "/home/$USER/.bashrc"; then
  echo
else echo alias nix-manager="/home/$USER/bin/nix-manager.sh" >> /home/$USER/.bashrc
fi
if [ "$EUID" = 0 ]
then echo -e "\e[1;31m Please run as regular user \e[0m"
  exit
fi

if [ -d /home/$USER/Nix-manager ];
   then
      echo -e "\e[1;34mNix-manager already exists in $USER's home, swapping clones anyway... \e[0m"
      sleep 1
      rm -rf /home/$USER/Nix-manager/tools
else
   echo -e "\e[1;34mNix-manager utility does not exist... \e[0m"
   read -p "Make /Nix-manager directory? (y) " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]
   then
       echo
       mkdir /home/$USER/Nix-manager
       cd /home/$USER/Nix-manager/
   else
      echo Cancelling...
      exit
   fi
fi
echo -e "Updating Nix-manager..."
git clone https://github.com/relogit/Nix-manager /home/$USER/Nix-manager/tools &> /dev/null
echo -e "\e[1;34m"
read -p " Nix-manager Menu | (e)dit (r)ebuild (b)ackup (t)est: [ENTER] to confirm letter:  " line
if [[ $line =~ ^[e]$ ]]
then sudo nano /etc/nixos/configuration.nix
echo -e "\e[1;34Rebuild now? \e[0m"
   read -p "Rebuild now? (y) " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]
   then sudo nixos-rebuild switch
   fi
fi

if [[ $line =~ ^[r]$ ]]
then sudo nixos-rebuild switch
fi

if [[ $line =~ ^[b]$ ]]
then echo -e "Backing up configuration.nix from $d"
     if [ -d /home/$USER/Nix-manager/MyBackups ];
     then echo
     else
     mkdir /home/$USER/Nix-manager/MyBackups
     fi
read -p " Type backup name: [ENTER] to confirm backup name:  " bkpname
if [[ -z "$bkpname" ]]
then
echo -e "\e[1;36m No backup name given, using current date.\e[0m"
mkdir /home/$USER/Nix-manager/MyBackups/$USER-nix-backup-$d
cp -r /etc/nixos/* /home/$USER/Nix-manager/MyBackups/$USER-nix-backup-$d
ls /home/$USER/Nix-manager/MyBackups
else
mkdir /home/$USER/Nix-manager/MyBackups/$USER-nix-backup-$bkpname
cp -r /etc/nixos/* /home/$USER/Nix-manager/MyBackups/$USER-nix-backup-$bkpname
ls /home/$USER/Nix-manager/MyBackups
fi
fi

if [[ $line =~ ^[t]$ ]]
then read -p " What package to try?:  " pkgname
echo -e "\e[1;36m Communicating to system. \e[0m"
nix-shell -p $pkgname
sleep 2
echo -e "\e[1;36m Running application $pkgname... \e[0m"
$pkgname
fi
