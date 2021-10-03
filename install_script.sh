#!/bin/bash
echo ""
echo "Development Tools Install Script"
echo ""

username=`logname`

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
read -p "Do you want to install Oracle Virtual Box? [y/n]: " virtualcont

#TODO: ADD Postgres under current name
#TODO: ADD code . for vscode
#TODO: ADD user for postgres
#TODO: ADD Gimp?
#TODO: FIX ZSH

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
	local package="$1" result="$2"
	if [[ $result == "pass" ]]
	then
		echo -e ${package^} "|\033[0;32m ${result^} \033[0m\n" >> log.txt
	elif [[ $result == "fail" ]]
	then
		echo -e ${package^} "|\033[0;31m ${result^} \033[0m\n" >> log.txt
	else
		echo -e ${package^} "|\033[0;33m ${result^} \033[0m\n" >> log.txt
  fi
}

function install_package(){
	local manager="$1" package="$2" optional="$3" optional2="$4"
	local yflag=""
	local status=""
	if [[ $manager == "apt" ]]
	then
		yflag="-y"
	fi
	sudo $manager install $package $optional $optional2
	if [[  $? == 0  ]]
	then
		status="pass"
	else
		status="fail"
  fi
	log_result $package $status
}

# INFO:
# To add additional packages to the script:
# call the install_package with string arguments:
# install_package <package_manager(e.g. apt)> <package_name e.g. virtualbox> <additional args e.g. --edge, --classic...>

############################### Useful Extras ############################

#Curl
install_package apt curl

#Sets Linux to use Local Time to fix clock sync when dual booting Windows - this is optional - comment out the following lines if you want this to be skipped by default
function set_time_local(){
	sudo timedatectl set-local-rtc 1
	if [[  $? == 0  ]]
	then
		log_result "Local Time" "pass"
	else
		log_result "Local Time" "fail"
	fi
}

# Reading result of prompt
if [[  $clockinput == "y"  ]]
then
	set_time_local
else
	log_result "Local Time" "skip" >> log.txt
fi

#Xclip - enables copying to clipboard via command line - useful e.g. for copying ZSH keys from file to paste to github
install_package apt xclip

################################### Workspaces ############################
install_package snap slack --classic
install_package snap zoom-client

###################################### Git #################################

#Git CLI
install_package apt git

#Git Kraken - awesome GUI for Git operations
install_package snap gitkraken --classic

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
install_package snap atom --classic
install_package snap code --classic
install_package snap intellij-idea-community --classic #check this one
install_package snap android-studio --classic

#Thonny - Lightweight IDE for MicroPython
install_package apt thonny

####################################LANGUAGES ###########################

install_package apt npm
install_package apt nodejs
install_package apt openjdk-8-jdk

# MonoDevelop for C#
#SOURCE: https://www.monodevelop.com/download/#fndtn-download-lin
function install_mono(){
	sudo apt install apt-transport-https dirmngr
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
	echo "deb https://download.mono-project.com/repo/ubuntu vs-bionic main" | tee /etc/apt/sources.list.d/mono-official-vs.list
	apt update
	install_package "mono-complete"
	if [[ $? == 0 ]]
	then
		log_result "Mono" "fass"
	else
		log_result "Mono" "fail"
	fi
}

# Reading result of prompt
if [[ $monoanswer == "y" ]]
then
	install_mono
else
	log_result "Mono" "Skip"
fi

####################################### DATABASE #################################

#MongoDB
function install_mongodb() {
	sudo apt-get -y install gnupg
	if [[  $? == 0 ]]
	then
		wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
		if [[  $? == 0  ]]
		then
			sudo apt-get -y install gnupg
			wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
			touch /etc/apt/sources.list.d/mongodb-org-5.0.list
			if [[  $? == 0  ]]
			then
				echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
				if [[  $? == 0  ]]
				then
					sudo apt-get update
					sudo apt-get install -y mongodb-org
					if [[  $? == 0  ]]
					then
							systemctl daemon-reload
							systemctl start mongod
							systemctl enable mongod
							log_result "mongodb" "pass"
						else
							log_result "mongodb" "fail"
					fi
				fi
			fi
		fi
	fi
}

install_mongodb

#MongoDB Compass
compassfile="mongodb-compass_1.28.4_amd64.deb"

function install_compass(){
if [  -f $compassfile  ]
then
	echo "file exists"
else
	wget https://downloads.mongodb.com/compass/mongodb-compass_1.28.4_amd64.deb
	sudo dpkg -i mongodb-compass_1.28.4_amd64.deb
	if [[  $? == 0  ]]
	then
		log_result "mongodb-compass" "pass"
	else
		log_result "mongodb-compass" "fail"
	fi
fi
}

install_compass

#Endpoint Testing GUI
install_package snap insomnia

#PostgresQL
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
install_package apt postgresql

#PgAdmin GUI for postgresqlcurl https://www.pgadmin.org/static/packages_pgadmin_org.pub |apt-key addsh -c 'echo deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main > /etc/apt/sources.list.d/pgadmin4.list && apt update'
install_package apt pgadmin4-desktop #check

#################################### PLANNING/DESIGN #############################

install_package snap drawio
install_package snap figma #check
install_package snap miro --edge

####################################### OTHER #########################################

#VirtualBox
if [[  $virtualcont == "y" ]]
then
	install_package apt virtualbox
else
	echo -e "VirtualBox|\033[0;33m Skip \033[0m\n" >> log.txt
fi

################################# ZSH ##############################################

function install_zsh(){
	sudo apt-get -y install zsh
}

function oh_my_zsh(){
	git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
	cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
	chsh -s $(which zsh)
}

if [[  $instzsh == "y"  ]]
then
 install_zsh
 oh_my_zsh
else
	log_result "oh-my-zsh" "skip"
fi

################################# CLEANUP ############################################

apt upgrade
apt update
apt --fix-broken install
apt autoremove

#################################### LOG ##############################################

echo "---------------------------------------------"
echo "Installation Log:"
echo "---------------------------------------------"
column log.txt -e -t -s "|"
echo "---------------------------------------------"
echo "If any steps fail, re-run the script"
exit 0
