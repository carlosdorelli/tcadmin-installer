#!/bin/bash

#
# TCAdmin Installer v0.1.0
#
# Created to install TCAdmin in a very simple and fast way
# Use this script in a new server
# Only tested in Ubuntu 20.04
#
# Created and maintened by Carlos Dorelli (Solrac#8440)
# https://github.com/carlosdorelli/tcadmin-installer
#

# Colors
function print_color(){
	NC='\033[0m'  # No color
	
	case $1 in
		"green") color='\033[0;32m' ;;
		"red") color='\033[0;31m'  ;;
		"*") color='\033[0m'  ;;
	esac
	echo -e "${color} $2 ${NC}"
}

# Check if user is sudo (root permissions).
if [[ "$(id -u)" -ne 0 ]]
then 
	print_color "red" "Only sudo users can run the script"
	exit 1
fi

# UPDATING AND UPGRADING PACKAGES
print_color "green" "[>] Updating and upgrading packages..."

sudo apt-get update && sudo apt-get upgrade -y;

print_color "green" "[>>] Packages upgrade with success!"

# INSTALLING DEPENDENCIES
print_color "green" "[>] Installing dependencies..."

sudo apt-get install libpcap0.8 util-linux lsof socat screen zip unzip -y;

print_color "green" "[>>] Dependencies installed with success!"

# INSTALLING STEAMCMD 32BIT LIBRARIES
print_color "green" "[>] Installing SteamCMD 32bit libraries..."

sudo apt-get install lib32stdc++6 -y;

print_color "green" "[>>] SteamCMD 32bit libraries installed with success!"

# INSTALLING MONO
print_color "green" "[>] Adding Xamarin repository to nano-project.com..."

sudo apt install gnupg ca-certificates;
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list;
sudo apt update;
sudo apt-get install mono-complete mono-vbnc mono-xsp -y;

print_color "green" "[>>] Xamarin repository added with success!"

# INSTALLING MARIADB
print_color "green" "[>] Installing MariaDB..."
print_color "green" "---------------Database Server Setup--------------"

sudo apt update
sudo apt install mariadb-server -y;

mysql -e "UPDATE mysql.user SET Password = PASSWORD('Kju95pMBgCXufX') WHERE User = 'root'"

mysql -e "CREATE DATABASE tcadmin"
mysql -e "CREATE USER 'tcadmin'@'localhost' IDENTIFIED BY 'HpjPGg3h5O3q'"
mysql -e "GRANT ALL PRIVILEGES ON tcadmin.* TO 'tcadmin'@'localhost'"
mysql -e "FLUSH PRIVILEGES"

print_color "green" "[>>] MariaDB Installed and configured with success!"
print_color "green" ""
print_color "green" "------------------Database Access-----------------"
print_color "green" ""
print_color "green" "Server: localhost or your IP"
print_color "green" "User: root *only to internal connections"
print_color "green" "Password: Kju95pMBgCXufX"
print_color "green" ""
print_color "green" "User: tcadmin *only to internal connections"
print_color "green" "Password: HpjPGg3h5O3q"
print_color "green" ""
print_color "green" "Database created: tcadmin"
print_color "green" ""
print_color "green" "--------------------------------------------------"

# DOWNLOAD AND STARTING TCADMIN
print_color "green" "[>] Downloading TCAdmin..."

sudo wget https://downloads.tcadmin.net/installer/tcadmin-2-bi.noarch.deb;dpkg -i tcadmin-2-bi.noarch.deb

print_color "green" "[>>] TCAdmin download and installed with success!"