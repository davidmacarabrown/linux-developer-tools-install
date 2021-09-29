#!/bin/bash
echo ""
echo "Development Tools Install Script"
echo ""

username=`logname`

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

#TODO: add input to ask if the user wants to enable optionals?
#TODO: move all optional input prompts (not the code itself) to the top?
#TODO: add Postgres under current name
#TODO: update readme remove sudo instructions, permissions will be increased after script starts
#TODO: add code . for vscode
#TODO: POSTICO for postgres GUI
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

function install_package(){
	local manager="$1" packagename="$2"
	sudo $manager install -y $packagename
	if [[  $? != 0  ]]
	then
		log_result $packagename "fail"
	else
		log_result $packagename "pass"
  fi
	}

############################### Useful Extras ############################

#Curl
install_package "apt" "curl"

#Setting Linux to use Local Time to fix clock sync when dual booting Windows - comment the following lines if you want this to be skipped.
read -p "Set Linux to use Local Time? (Useful when dual booting to prevent clock from being out by one hour in Windows) [y/n]: " clockinput
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
install_package "apt" "xclip"

################################### Workspaces ############################
install_package "snap" "slack --classic"
install_package "snap" "zoom-client"

###################################### Git #################################

#Git CLI
install_package "apt" "git"

#Global .gitignore
ignorefile="./.gitingore_global"
if [ ! -f $ignorefile  ]
then
	touch .gitignore_global
fi
echo -e "Global Ignore|\033[0;32m Pass \033[0m\n" >> log.txt
echo "**/node_modules" >> .gitignore_global
if [[  $? == 0  ]]
then
	echo -e "Node Modules|\033[0;32m Pass \033[0m\n" >> log.txt
else
	echo -e "Node Modules|\033[0;31m Fail \033[0m\n" >> log.txt
fi

#Adding global ignore to Git config
git config --global core.excludesfile .gitignore_global
if [[  $? == 0  ]]
then
	echo -e "Global Config|\033[0;32m Pass \033[0m\n" >> log.txt
else
	echo -e "Global Config|\033[0;31m Fail \033[0m\n" >> log.txt
fi
	echo -e "Global Ignore|\033[0;31m Fail \033[0m\n" >> log.txt


################################### Editors / IDE #########################
# Add your own... :D
install_package "snap" "atom --classic"
install_package "snap" "code --classic"
install_package "snap" "intellij --classic"
install_package "snap" "android-studio --classic"

#Thonny - Lightweight IDE for MicroPython
install_package "apt" "thonny"

####################################LANGUAGES ###########################

install_package "apt" "npm"
install_package "apt" "nodejs"
install_package "apt" "openjdk-8-jdk"

# MonoDevelop for C#
#SOURCE: https://www.monodevelop.com/download/#fndtn-download-lin

# Add Mono Repository
read -p "Install Mono for C#? [y/n]: " monoanswer
if [[ $monoanswer == "y" ]]
then
	apt install apt-transport-https dirmngr
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
	echo "deb https://download.mono-project.com/repo/ubuntu vs-bionic main" | tee /etc/apt/sources.list.d/mono-official-vs.list
	apt update
	apt-get -y install mono-complete
	if [[  $? == 0  ]]
	then
		log_result "mono" "pass"
	else
		apt --fix-broken -y install
		if [[  $? == 0  ]]
		then
			log_result "mono" "pass"
		else
			log_result "mono" "fail"
		fi
	fi
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
					apt --fix-broken -y install
					if [[  $? == 0  ]]
					then
							systemctl daemon-reload
							systemctl start mongod
							systemctl enable mongod
							log_result $packagename "pass"
					else
						echo -e "MongoDB|\033[0;31m Fail \033[0m\n" >> log.txt
					fi
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
		echo -e "Compass|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		apt update
		apt upgrade
		apt --fix-broken -y install
		if [[  $? == 0  ]]
		then
			dpkg -i mongodb-compass_1.28.4_amd64.deb
			if [[  $? == 0  ]]
			then
				echo -e "Compass|\033[0;32m Pass \033[0m\n" >> log.txt
			fi
		else
			echo -e "Compass|\033[0;31m Fail \033[0m\n" >> log.txt
		fi
	fi
fi

install_package "snap" "insomnia"
install_package "snap" "postman"

#PostgresQL
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
apt-get -y install postgresql
if [[  $? == 0  ]]
then
	echo -e "PostgresQL|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "PostgresQL|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "PostgresQL|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#################################### PLANNING/DESIGN #############################

install_package "snap" "figma"
install_package "snap" "--edge miro"
install_package "snap" "drawio"


####################################### OTHER #########################################

#VirtualBox
read -p "Do you want to install Oracle Virtual Box? [y/n]: " virtualcont
if [[  $virtualcont == "y" ]]
then
	install_package "apt" "virtialbox"
else
	echo -e "VirtualBox|\033[0;33m Skip \033[0m\n" >> log.txt
fi

################################# CLEANUP ############################################

apt --fix-broken -y install
apt autoremove

#################################### LOG ##############################################


#echo -n "Review results and press enter to continue to ZSH install"

################################# ZSH ##############################################
#read continueanswer

read -p "Install Oh-My-Zsh? [y/n]: " instzsh
if [[  $instzsh == "y"  ]]
then
	apt-get -y install zsh
	git clone https://github.com/ohmyzsh/ohmyzsh.git ./.oh-my-zsh
	cp ./.oh-my-zsh/templates/zshrc.zsh-template ./.zshrc
	sudo -u $username cnsh -s $(which zsh)
fi

echo "---------------------------------------------"
echo "Installation Log:"
echo "---------------------------------------------"
column log.txt -e -t -s "|"
echo "---------------------------------------------"
echo "If any steps fail, re-run the script"
exit 0
