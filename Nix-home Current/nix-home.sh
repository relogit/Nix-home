clear
d=`date +%y%m%d_%H:%M.%S`

echo -e "\e[34m Nix-home revision 0.0.6 (PRE) made by relogit. running as user '$USER'.\e[0m

"
if grep -q git "/etc/nixos/configuration.nix";
then echo "" > /dev/null
else echo -e "\e[1;36mFailed to find git in configuration.nix.\e[0m"
fi

if grep -q Nix-home "/home/$USER/.bashrc"; then
echo "" > /dev/null
else echo alias Nix-home="/home/$USER/bin/Nix-home.sh" >> /home/$USER/.bashrc
fi
if [ "$EUID" = 0 ]
then echo -e "\e[1;31m Please run as regular user \e[0m"
  exit
fi
if [ -d /home/$USER/Nix-home ];
   then
      rm -rf /home/$USER/Nix-home/tools
else
   echo
       mkdir /home/$USER/Nix-home
       cd /home/$USER/Nix-home/
fi
git clone https://github.com/relogit/Nix-home /home/$USER/Nix-home/tools &> /dev/null

clear
echo -n -e "\e[1;34m >>> Nix-home Menu | edit, rebuild, backup, try, create: \e[0m"
read nixmenu

case $nixmenu in

  edit | e | E | ee | $EDITOR)
    clear
    echo -n -e "\e[1;32m Editing with $EDITOR. \e[0m
 "
    sudo $EDITOR /etc/nixos/configuration.nix
    clear

     echo -n -e "\e[1;36m rebuild, edit, upgrade  \e[0m"
     read ce1
    
     case $ce1 in

     edit | e | E | ee | $EDITOR)
     sudo $EDITOR /etc/nixos/configuration.nix
     echo
     ;;

     rebuild | r | R | build)
     sudo nixos-rebuild switch
     ;;

     upgrade | u | U | update)
     sudo nixos-rebuild switch --upgrade
     ;;

     '')
      echo -n
      ;;
      esac

   ;;
   
  rebuild | r | R | build)
    clear
    sudo nixos-rebuild switch
    ;;

  backup | b | B | bkp)
    clear
    echo -e "\e[1;32m Backing up /etc/nixos/ from $d to... what dir? \e[0m"
    lsblk -p -b
    echo -e "\e[1;31m Attempting to backup to directories you dont have access to will fail!\e[0m"
    echo -n -e "\e[1;32m Default directory selected is /home/$USER/Nix-home/my-backups/ \e[0m
 \e[1;34m>>> Backup to... \e[0m"
   read bkpdir
     case $bkpdir in
       
      /)
      echo
      ;;

      '')
      bkpdir='/home/$USER/Nix-home/my-backups/'
      if [ -d /home/$USER/Nix-home/my-backups ];
      then echo
      else mkdir /home/$USER/Nix-home/my-backups
      fi
      ;;

    esac
    clear
    echo -e " Selected $bkpdir "
    echo -e " Type backup name: [ENTER] to confirm backup name:  " 
    read bkpname

   case $bkpname in

    '')
    echo -e "\e[1;36m No backup name given, using current date.\e[0m"
    mkdir -p $bkpdir$USER-nix-backup-$d
    cp -r /etc/nixos/* $bkpdir$USER-nix-backup-$d
    echo -e "\e[1;32m"
    ls $bkpdir
   ;;

   $bkpname)
   mkdir -p $bkpdir$USER-nix-backup-$bkpname
    cp -r /etc/nixos/* $bkpdir$USER-nix-backup-$bkpname
    echo -e "\e[1;32m"
    ls $bkpdir
    ;;

   esac
   ;;

  try | t | T | test)
  clear
  echo -e "\e[1;32m Package libaries: https://search.nixos.org/packages \e[0m"
  echo -e -n "\e[1;36m >>> Nix-home [try] \e[0m " 
  read "pkgname"
  clear
  echo -e "\e[1;36m Once Nix-shell starts, type '$pkgname'. To return to Nix-home, type 'exit'\e[0m"
  sleep 4

  clear
  nix-shell --quiet -p $pkgname
  echo -e "\e[1;34m Edit configuration.nix? (yes) \e[0m"
  read editfromshell

  case $editfromshell in

   y | Y)
   sudo $EDITOR /etc/nixos/configuration.nix
   read -p "Rebuild? (y)  " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]
   then sudo nixos-rebuild switch
   fi
   ;;
  esac 
  ;;
      
  create | c | C | make)
  mkdir /home/$USER/Nix-home/my-configs
  echo -e -n "\e[1;36m Type configuration name: [ENTER] to confirm configuration name:  \e[0m"
  read cfgname
  case $cfgname in

   '')
    echo -e "\e[1;36m No configuration name given, using current date.\e[0m"
    cp /home/$USER/Nix-home/tools/Nix-23.11/configuration.nix /home/$USER/Nix-home/my-configs/configuration-$d.nix
    echo -e "\e[1;32m"
    $EDITOR /home/$USER/Nix-home/my-configs/configuration-$d.nix
    ;;

   
   *) 
    cp /home/$USER/Nix-home/tools/Nix-23.11/configuration.nix /home/$USER/Nix-home/my-configs/configuration-$cfgname.nix
    echo -e "\e[1;32m"
    $EDITOR /home/$USER/Nix-home/my-configs/configuration-$cfgname.nix
    ;;

    esac
    ;;
esac
clear
