d=`date +%m:%d:%y:%H:%M:%S`

echo -e "\e[34mNixOS Editor revision 0.0.1. running as user '$USER'\e[0m"
echo -e "Please ensure the 'git' package is added to your config."
if grep -q nixeditor "/home/$USER/.bashrc"; then
  echo
  echo "NixEditor alias already exists, will not make another."
else echo alias nixeditor="/home/$USER/bin/nixeditor.sh" >> /home/$USER/.bashrc
fi
sleep 2
if [ "$EUID" = 0 ]
then echo -e "\e[1;31m Please run as regular user \e[0m"
  exit
fi
if [ -d /home/$USER/NixEditor ];
   then
      echo -e "\e[1;34mNixEditor utility already exists in $USER's home, switching copies anyway in 5 seconds... \e[0m"
      sleep 5
      rm -rf /home/$USER/NixEditor/Tools
else
   echo -e "\e[1;34mNixEditor utility does not exist... \e[0m"
   read -p "Make /NixEditor directory? (y) " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]
   then
       echo
       sleep 1
       mkdir /home/$USER/NixEditor
       cd /home/$USER/NixEditor/
   else
      echo Cancelling...
      sleep 1
      exit
   fi
fi
echo
git clone --verbose --progress https://github.com/relogit/NixOS-Editor /home/$USER/NixEditor/Tools
echo -e "\e[1;36m"
read -p " NixEditor (e)dit (r)ebuild (b)ackup: [ENTER] to confirm letter:  " line
echo -e "\e[0m"
if [[ $line =~ ^[e]$ ]]
then sudo nano /etc/nixos/configuration.nix
fi

if [[ $line =~ ^[r]$ ]]
then sudo nixos-rebuild switch
fi

if [[ $line =~ ^[b]$ ]]
then echo -e "Backing up configuration.nix from $d"
     if [ -d /home/$USER/NixEditor/MyBackups ];
     then echo
     else
     mkdir /home/$USER/NixEditor/MyBackups
     fi
mkdir /home/$USER/NixEditor/MyBackups/$USER-nix-backup-$d
cp -r /etc/nixos/* /home/$USER/NixEditor/MyBackups/$USER-nix-backup-$d
ls /home/$USER/NixEditor/MyBackups
fi
