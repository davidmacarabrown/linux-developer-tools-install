#!/bin/bash
echo ""
echo "Development Tools Install Script"
echo ""
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

# Prompts for local time fix and virtualbox
read -p "Set Linux to use Local Time? (Useful when dual booting to prevent clock from being out by one hour in Windows) [y/n]: " clockinput
read -p "Do you want to install Oracle Virtual Box? [y/n]: " virtualcont

# Checking for existing log file and creating one
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

function cleanup(){
	sudo apt upgrade
	sudo apt -y update
	sudo apt --fix-broken install
	sudo apt -y autoremove
}

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
	sudo $manager install $yflag $package $optional $optional2
	if [[  $? == 0  ]]
	then
		status="pass"
	elif [[ $manager == "apt" ]]
		then
			cleanup
			sudo $manager install $yflag $package $optional $optional2
			if [[  $? == 0  ]]
			then
				status="pass"
			else status="fail"
			fi
		else
		status="fail"
  fi
	log_result $package $status
}

################################### INFO ################################

# To add additional packages to the script:
# install_package <package_manager(e.g. apt)> <package_name e.g. virtualbox> <additional args e.g. --edge, --classic...>

############################### Useful Extras ############################

# Curl
install_package apt curl

# Sets Linux to use Local Time to fix clock sync when dual booting Windows
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

# Xclip - enables copying to clipboard via command line - useful e.g. for copying ZSH keys from file to paste to github
install_package apt xclip

################################### Workspaces ############################

install_package snap slack --classic
install_package snap zoom-client

###################################### Git #################################

# Git CLI
install_package apt git

# Git Kraken - awesome GUI for Git operations
install_package snap gitkraken --classic

# Global .gitignore
ignorefile="./.gitingore_global"
if [ ! -f $ignorefile  ]
then
	touch .gitignore_global
fi

# Adding node_modules to global ignore. This can easily be added to by using: echo ""<what-to-ignore>"" >> .gitignore_global
echo "**/node_modules" >> .gitignore_global

# Adding global ignore to Git config
git config --global core.excludesfile .gitignore_global

################################### Editors / IDE #########################
# Add your own... :D
install_package snap atom --classic
install_package snap code --classic
install_package snap intellij-idea-community --classic #check this one
install_package snap android-studio --classic

# Thonny - Lightweight IDE for MicroPython
install_package apt thonny

####################################LANGUAGES ###########################


function install_node(){
	curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
	install_package apt nodejs
}

install_node

install_package apt npm
install_package apt openjdk-8-jdk

#Yarn
install_yarn(){
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt update
	install_package apt yarn
}

install_yarn
####################################### DATABASE #################################

# MongoDB
function install_mongodb() {
	mongodbstatus="fail"
	sudo apt-get -y install gnupg
	if [[  $? == 0 ]]
	then
		wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
		if [[  $? == 0  ]]
		then
			echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
			if [[  $? == 0  ]]
			then
				sudo apt-get update
				sudo apt-get install -y mongodb-org
				if [[  $? == 0  ]]
				then
					systemctl daemon-reload
					systemctl start mongod
					systemctl enable mongod
					mongodbstatus="pass"
				fi
			fi
		fi
	fi
	log_result "MongoDB" $mongodbstatus
}

install_mongodb

# MongoDB Compass
compassfile="mongodb-compass_1.28.4_amd64.deb"

function install_compass(){
	compassstatus="fail"
	if [  -f $compassfile  ]
	then
		echo "file exists"
	else
		wget https://downloads.mongodb.com/compass/mongodb-compass_1.28.4_amd64.deb
		sudo dpkg -i mongodb-compass_1.28.4_amd64.deb
		if [[  $? == 0  ]]
		then
			compassstatus="pass"
			rm mongodb-compass_1.28.4_amd64.deb
		else
			cleanup
			sudo dpkg -i mongodb-compass_1.28.4_amd64.deb
			if [[  $? == 0  ]]
			then
				compassstatus="pass"
				rm mongodb-compass_1.28.4_amd64.deb
			fi
		fi
	fi

	log_result "MongoDB-Compass" $compassstatus
}

install_compass

# PostgresQL
function install_psql(){
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	sudo apt-get update
	install_package apt postgresql
}

# PgAdmin GUI for postgresqlcurl https://www.pgadmin.org/static/packages_pgadmin_org.pub |apt-key addsh -c 'echo deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main > /etc/apt/sources.list.d/pgadmin4.list && apt update'
function install_pgadmin(){
	sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
	sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
	install_package apt pgadmin4-desktop
}

install_psql
install_pgadmin

#################################### ENDPOINT TESTING ###############################

install_package snap insomnia

#################################### PLANNING/DESIGN ################################

install_package snap drawio
install_package snap figma-linux
install_package snap miro --edge

####################################### OTHER #########################################

# VirtualBox
if [[  $virtualcont == "y" ]]
then
	install_package apt virtualbox
else
	log_result "virtualbox" "skip"
fi

################################# ZSH ##############################################

zshresult=1
function install_zsh(){
	sudo apt-get -y install zsh
	zshresult=$?
}

function oh_my_zsh(){
	git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
	cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
	chsh -s $(which zsh)
}


install_zsh
oh_my_zsh

if [[ $zshresult == 0 ]]
then
	log_result "oh-my-zsh" "pass"
else
	log_result "oh-my-zsh" "fail"
fi

################################# CLEANUP ############################################

cleanup

#################################### LOG ##############################################

echo "---------------------------------------------"
echo "Installation Log:"
echo "---------------------------------------------"
column log.txt -e -t -s "|"
echo "---------------------------------------------"
echo "If any steps fail, re-run the script"
exit 0
