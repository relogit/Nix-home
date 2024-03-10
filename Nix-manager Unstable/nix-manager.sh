d=`date +%y%m%d_%H:%M.%S`

echo -e "\e[34m Nix-manager revision 0.0.5 made by relogit. running as user '$USER'.\e[0m"
if grep -q git "/etc/nixos/configuration.nix";
then echo "" > /dev/null
else echo -e "\e[1;36mFailed to find git in configuration.nix.\e[0m"
fi

if grep -q nix-manager "/home/$USER/.bashrc"; then
echo "" > /dev/null
else echo alias nix-manager="/home/$USER/bin/nix-manager.sh" >> /home/$USER/.bashrc
fi
if [ "$EUID" = 0 ]
then echo -e "\e[1;31m Please run as regular user \e[0m"
  exit
fi
if [ -d /home/$USER/Nix-manager ];
   then
      rm -rf /home/$USER/Nix-manager/tools
else
   echo
   echo -e "\e[1;32m First-time startup! \e[0m"
   read -p " Make /Nix-manager directory? (y) " -n 1 -r
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
git clone https://github.com/relogit/Nix-manager /home/$USER/Nix-manager/tools &> /dev/null

echo -e "\e[1;34m"
read -p " >>> Nix-manager Menu | (e)dit (r)ebuild (b)ackup (t)est (c)reate:  " -n 1 -r line
echo -e "\e[0m"
if [[ $line =~ ^[Ee]$ ]]
then sudo nano /etc/nixos/configuration.nix
   read -p "(r)ebuild r(e)dit  " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]
   then sudo nixos-rebuild switch
   fi
   if [[ $REPLY =~ ^[Ee]$ ]]
   then sudo nano /etc/nixos/configuration.nix
   read -p "Rebuild? (y)  " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]
   then sudo nixos-rebuild switch
   fi
   fi
fi

if [[ $line =~ ^[Rr]$ ]]
then sudo nixos-rebuild switch
fi

if [[ $line =~ ^[Bb]$ ]]
then echo -e "\e[1;32m Backing up configuration.nix from $d to /home/$USER/Nix-manager/my-backups \e[0m"
     if [ -d /home/$USER/Nix-manager/my-backups ];
     then echo
     else
     mkdir /home/$USER/Nix-manager/my-backups
     fi
read -p " Type backup name: [ENTER] to confirm backup name:  " bkpname
if [[ -z "$bkpname" ]]
then
echo -e "\e[1;36m No backup name given, using current date.\e[0m"
mkdir /home/$USER/Nix-manager/my-backups/$USER-nix-backup-$d
cp -r /etc/nixos/* /home/$USER/Nix-manager/my-backups/$USER-nix-backup-$d
echo -e "\e[1;32m"
ls /home/$USER/Nix-manager/my-backups
else
mkdir /home/$USER/Nix-manager/my-backups/$USER-nix-backup-$bkpname
cp -r /etc/nixos/* /home/$USER/Nix-manager/my-backups/$USER-nix-backup-$bkpname
echo -e "\e[1;32m"
ls /home/$USER/Nix-manager/my-backups
fi
fi

if [[ $line =~ ^[Tt]$ ]]
then echo -e "\e[1;32m The 'test' command utilizes nix-shell, it runs as silent, so make sure you get the package name right!
\e[0m"
read -p " Please specify a package.To make sure this is the correct package name, refer to https://search.nixos.org/packages
 Package name:   " pkgname
echo -e "\e[1;36m Once Nix-shell starts, type '$pkgname'. To return to Nix-manager, type 'exit'\e[0m"
nix-shell --quiet -p $pkgname
echo -e "\e[1;34m"
read -p "Edit configuration.nix? (y) " -n 1 -r editfromshell
echo -e "\e[0m"
if [[ $editfromshell =~ ^[Yy]$ ]]
then sudo nano /etc/nixos/configuration.nix
   read -p "Rebuild? (y)  " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]
   then sudo nixos-rebuild switch
   fi
   fi
fi
if [[ $line =~ ^[Cc]$ ]]
then mkdir /home/$USER/Nix-manager/my-configs
read -p " Type configuration name: [ENTER] to confirm configuration name:  " cfgname
if [[ -z "$cfgname" ]]
then
echo -e "\e[1;36m No configuration name given, using current date.\e[0m"
cp /home/$USER/Nix-manager/tools/Nix-23.11/configuration.nix /home/$USER/Nix-manager/my-configs/configuration-$d.nix
echo -e "\e[1;32m"
nano /home/$USER/Nix-manager/my-configs/configuration-$d.nix
else
cp /home/$USER/Nix-manager/tools/Nix-23.11/configuration.nix /home/$USER/Nix-manager/my-configs/configuration-$cfgname.nix
echo -e "\e[1;32m"
nano /home/$USER/Nix-manager/my-configs/configuration-$cfgname.nix
fi
fi
