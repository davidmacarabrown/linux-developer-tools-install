#!/bin/bash
echo ""
echo "Development Tools Install Script"
echo ""

username=`logname`

#Checking forprivileges
if [ "$EUID" != 0 ]
	then echo "Please run this script as root by entering: sudo <path to script>"
	exit 0
fi

echo "This script is provided without warranty of any kind."
echo ""
echo "Before running this script it is advised to run the following commands in the terminal to update packages:"
echo ""
echo "sudo apt-get update"
echo "sudo apt-get upgrade"
echo "sudo snap refresh"
echo ""
read -p "It is advised to download and apply any outstanding updates before running this script. Continue? [y/n]: " answer1

if [[  $answer1 == "n"  ]]
then
	echo "Exit"
	exit 0
fi
echo "Continue"

#prompts for installing ZSH, clock adjustment and Mono C#
read -p "Install Oh-My-Zsh? [y/n]: " instzsh
read -p "Set Linux to use Local Time? (Useful when dual booting to prevent clock from being out by one hour in Windows) [y/n]: " clockinput
read -p "Install Mono for C#? [y/n]: " monoanswer

#TODO: add Postgres under current name
#TODO: update readme remove sudo instructions, permissions will be increased after script starts?
#TODO: add code . for vscode
#TODO: ADD user for postgres

#checking for existing log file and creating one
echo "Creating log file"
logfile="./log.txt"
if [[  -f $logfile  ]]
then
	rm log.txt
fi
touch log.txt
echo -e "Install|Result" >> log.txt
echo -e "-----------|-----------" >> log.txt

############################### Functions ################################

function log_result(){
	local packagename="$1" result="$2"
	if [[ $result == "pass" ]]
	then
		echo -e "$packagename |\033[0;32m pass \033[0m\n" >> log.txt
	elif [[ $result == "fail" ]]
	then
		echo -e "$packagename |\033[0;31m fail \033[0m\n" >> log.txt
	else
		echo -e "$packagename |\033[0;33m skip \033[0m\n" >> log.txt
  fi
}

function install_apt(){
	local packagename="$1"
	apt install -y $packagename
	if [[  $? == 0  ]]
	then
		log_result $packagename "pass"
	else
		log_result $packagename "fail"
  fi
	}

function install_snap(){
	local packagename="$1"
	snap install $packagename
	if [[  $? == 0  ]]
	then
		log_result $packagename "pass"
	else
		log_result $packagename "fail"
  fi
	}

############################### Useful Extras ############################

#Curl
install_apt "curl"

#Sets Linux to use Local Time to fix clock sync when dual booting Windows - this is optional - comment the following lines if you want this to be skipped by default
if [[  $clockinput == "y"  ]]
then
	timedatectl set-local-rtc 1
	if [[  $? == 0  ]]
	then
		echo -e "Local Time|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Local Time|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
else
	echo -e "Local Time|\033[0;33m Skip \033[0m\n" >> log.txt
fi

#Xclip - enables copying to clipboard via command line - useful for copying ZSH keys to paste to github
install_apt "xclip"

################################### Workspaces ############################
install_snap "slack --classic"
install_snap "zoom-client"

###################################### Git #################################

#Git CLI
install_apt "git"

#Git Kraken - awesome GUI for Git operations
instal_packagesnap "gitkraken"

#Global .gitignore
ignorefile="./.gitingore_global"
if [ ! -f $ignorefile  ]
then
	touch .gitignore_global
fi

#Adding node_modules to global ignore this can easily be added to by using: [ echo <what-to-ignore> >> .gitignore_global ]
echo "**/node_modules" >> .gitignore_global

#Adding global ignore to Git config
git config --global core.excludesfile .gitignore_global

################################### Editors / IDE #########################
# Add your own... :D
install_snap "atom --classic"
install_snap "code --classic"
install_snap "intellij --classic"
install_snap "android-studio --classic"

#Thonny - Lightweight IDE for MicroPython
install_apt "thonny"

####################################LANGUAGES ###########################

install_apt "npm"
install_apt "nodejs"
install_apt "openjdk-8-jdk"

# MonoDevelop for C#
#SOURCE: https://www.monodevelop.com/download/#fndtn-download-lin
if [[ $monoanswer == "y" ]]
then
	apt install apt-transport-https dirmngr
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
	echo "deb https://download.mono-project.com/repo/ubuntu vs-bionic main" | tee /etc/apt/sources.list.d/mono-official-vs.list
	apt update
	install_apt "mono-complete"
else
	echo -e "Mono C#|\033[0;33m Skip \033[0m\n" >> log.txt
fi

####################################### DATABASE #################################

#MongoDB
apt-get -y install gnupg
if [[  $? == 0 ]]
then
	wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
	if [[  $? == 0  ]]
	then
		apt-get -y install gnupg
		wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
		touch /etc/apt/sources.list.d/mongodb-org-5.0.list
		if [[  $? == 0  ]]
		then
			echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
			if [[  $? == 0  ]]
			then
				apt-get update
				apt-get install -y mongodb-org
				if [[  $? == 0  ]]
				then
						systemctl daemon-reload
						systemctl start mongod
						systemctl enable mongod
						log_result mongodb"pass"
					else
						log_result "mongodb" "fail"
				fi
			fi
		fi
	fi
fi

#MongoDB Compass
compassfile="mongodb-compass_1.28.4_amd64.deb"
if [  -f $compassfile  ]
then
	echo "file exists"
else
	wget https://downloads.mongodb.com/compass/mongodb-compass_1.28.4_amd64.deb
	dpkg -i mongodb-compass_1.28.4_amd64.deb
	if [[  $? == 0  ]]
	then
		log_result "mongodb-compass" "pass"
	else
			log_result "mongodb-compass" "fail"
	fi
fi

#Endpoint Testing GUI
install_snap "insomnia"
install_snap "postman"

#PostgresQL
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
install_apt "postgresql"

#PgAdmin GUI for postgresqlcurl https://www.pgadmin.org/static/packages_pgadmin_org.pub |apt-key addsh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
install_apt "pgadmin4-desktop"

#################################### PLANNING/DESIGN #############################

install_snap "drawio"
install_snap "figma"

snap install miro --edge
if [[ $? == 0 ]]
then
	log_result "miro" "pass"
else
	log_result "miro" "fail"
fi

####################################### OTHER #########################################

#VirtualBox
read -p "Do you want to install Oracle Virtual Box? [y/n]: " virtualcont
if [[  $virtualcont == "y" ]]
then
	install_apt "virtualbox"
else
	echo -e "VirtualBox|\033[0;33m Skip \033[0m\n" >> log.txt
fi

################################# CLEANUP ############################################

apt upgrade
apt update
apt --fix-broken install
apt autoremove

################################# ZSH ##############################################

read continueanswer
function install_ohmyzsh(){
	apt-get -y install zsh
	git clone https://github.com/ohmyzsh/ohmyzsh.git ./.oh-my-zsh
	cp ./.oh-my-zsh/templates/zshrc.zsh-template ./.zshrc
	-u $username cnsh -s $(which zsh)
	log_result "oh-my-zsh" "pass"
}

if [[  $instzsh == "y"  ]]
then
 install_ohmyzsh
else
	log_result "oh-my-zsh" "skip"
fi

#################################### LOG ##############################################

echo "---------------------------------------------"
echo "Installation Log:"
echo "---------------------------------------------"
column log.txt -e -t -s "|"
echo "---------------------------------------------"
echo "If any steps fail, re-run the script"
exit 0
