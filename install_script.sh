#!/bin/bash
echo ""
echo ""
echo "Development Tools Install Script"
echo ""
echo ""
echo "This script is provided without warranty of any kind."
echo ""
echo ""
echo "Before running this script it is advised to run the following commands in the terminal to update packages:"
echo ""
echo ""
echo "sudo apt-get update"
echo "sudo apt-get upgrade"
echo "sudo snap refresh"
echo ""
echo ""
echo ""
read -p "It is advised to download and apply any outstanding updates before running this script. Continue? [y/n]: " answer1

if [[  $answer1 == "n"  ]]
then
	echo "Exit"
	exit 0
fi
echo "Continue"

#checking for existing log file and creating one
echo "Creating Log File at ./log.txt"
logfile="./log.txt"
if [[  -f $logfile  ]]
then
	sudo rm log.txt
fi
touch log.txt
echo -e "Install|Result" >> log.txt
echo -e "-------|------" >> log.txt

############################### Useful Extras ############################

#Curl
sudo apt install -y curl
if [[  $? == 0  ]]
then
	echo -e "Curl|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[ $? == 0 ]]
	then
		echo -e "Curl|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Curl|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#Setting Linux to use Local Time to fix clock sync when dual booting Windows - comment the following lines if you want this to be skipped.

read -p "Set Linux to use Local Time? (Useful when dual booting to prevent clock from being out by one hour in Windows) [y/n]: " clockinput
if [[  $clockinput == "y"  ]]
then
	sudo timedatectl set-local-rtc 1
	if [[  $? == 0  ]]
	then
		echo -e "Local Time|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Local Time|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
else
	echo -e "Local Time|\033[0;33m Skip \033[0m\n" >> log.txt
fi

#xclip - enables copying to clipboard via command line - useful for copying ZSH keys to paste to github
sudo apt-get -y install xclip
if [[  $? == 0  ]]
then
	echo -e "XClip|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "XClip|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "XClip|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#Slack Messaging Platform
sudo snap install slack --classic
if [[  $? == 0  ]]
then
	echo -e "Slack|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Slack|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Slack|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

##Zoom
sudo snap install zoom-client
if [[  $? == 0  ]]
then
	echo -e "Zoom|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Zoom|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Zoom|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi


#Discord - Better than zoom and no time limits with Screensharing that doesn't trash your FPS
sudo snap install discord
if [[  $? == 0  ]]
then
	echo -e "Discord|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Discord|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Discord|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

###################################### Git #################################

#Git Bash
sudo apt-get -y install git
if [[  $? == 0  ]]
then
	echo -e "Git Bash|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Git Bash|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Git Bash|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

echo Creating .gitignore_global
ignorefile="./.gitingore_global"
if [  -f $ignorefile  ]
then
	rm -r .gitingore_global
fi

touch .gitignore_global
if [[  $? == 0  ]]
then
		echo -e "Global Ignore|\033[0;32m Pass \033[0m\n" >> log.txt
		sudo echo "**/node_modules" >> .gitignore_global
		if [[  $? == 0  ]]
		then
				echo -e "Node Modules|\033[0;32m Pass \033[0m\n" >> log.txt
		else
				echo -e "Node Modules|\033[0;31m Fail \033[0m\n" >> log.txt
		fi

		git config --global core.excludesfile .gitignore_global
		if [[  $? == 0  ]]
		then
				echo -e "Global Config|\033[0;32m Pass \033[0m\n" >> log.txt
		else
				echo -e "Global Config|\033[0;31m Fail \033[0m\n" >> log.txt
		fi
else
		echo -e "Global Ignore|\033[0;31m Fail \033[0m\n" >> log.txt
fi
################################### Editors / IDE #########################
# Add your own... :D

#Atom
sudo snap install atom --classic
if [[  $? == 0  ]]
then
	echo -e "Atom|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Atom|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Atom|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#VSCode
sudo snap install code --classic
if [[ $? == 0  ]]
then
	echo -e "VSCode|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "VSCode|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "VSCode|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi


#IntelliJ Community Edition
sudo snap install intellij-idea-community --classic
if [[  $? == 0  ]]
then
	echo -e "IntelliJ|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "IntelliJ|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "IntelliJ|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#Android Studio
sudo snap refresh
sudo snap install android-studio --classic
if [[  $? == 0  ]]
then
	echo -e "Android Studio|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Android Studio|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Android Studio|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#Pycharm Community Edition
sudo snap install pycharm-community --classic
if [[  $? == 0  ]]
then
	echo -e "Pycharm|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Pycharm|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Pycharm|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#Thonny - Lightweight IDE for MicroPython
sudo apt -y install thonny
if [[  $? == 0  ]]
then
	echo -e "Thonny|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Thonny|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Thonny|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

####################################LANGUAGES ###########################

##JavaScript

#Node Package Manager
sudo apt install -y npm
if [[  $? == 0  ]]
then
	echo -e "NPM|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[ $? == 0  ]]
	then
		echo -e "NPM|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "NPM|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi


#NodeJS
sudo apt install -y nodejs
if [[  $? == 0  ]]
then
	echo -e "NodeJS|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "NodeJS|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "NodeJS|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#Java
sudo apt-get install -y openjdk-8-jdk
if [[  $? == 0  ]]
then
	echo -e "Java JDK 8|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Java JDK 8|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Java JDK 8|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

## MonoDevelop for C#
#SOURCE: https://www.monodevelop.com/download/#fndtn-download-lin

#Add Mono Repository
#read -p "Install Mono for C#? [y/n]: " monoanswer
#if [[ $monoanswer == "y" ]]
#then
#	sudo apt install apt-transport-https dirmngr
#	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
#	echo "deb https://download.mono-project.com/repo/ubuntu vs-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-vs.list
#	sudo apt update

	#Install MonoDevelop

#	sudo apt-get -y install mono-complete
#	if [[  $? == 0  ]]
#	then
#		echo -e "Mono C#|\033[0;32m Pass \033[0m\n" >> log.txt
#	else
#		apt --fix-broken -y install
#		if [[  $? == 0  ]]
#		then
#			echo -e "Mono C#|\033[0;32m Pass \033[0m\n" >> log.txt
#		else
#			echo -e "Mono C#|\033[0;31m Fail \033[0m\n" >> log.txt
#		fi
#	fi
#else
#	echo -e "Mono C#|\033[0;33m Skip \033[0m\n" >> log.txt
#fi

####################################### DATABASE #################################

#MongoDB
sudo apt-get -y install gnupg
if [[  $? == 0 ]]
then
	wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
	if [[  $? == 0  ]]
	then
		sudo apt-get -y install gnupg
		wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
		touch /etc/apt/sources.list.d/mongodb-org-5.0.list
		if [[  $? == 0  ]]
		then
			echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
			if [[  $? == 0  ]]
			then
				sudo apt-get update
				sudo apt-get install -y mongodb-org
				if [[  $? == 0  ]]
				then
						sudo systemctl daemon-reload
						sudo systemctl start mongod
						sudo systemctl enable mongod
						echo -e "MongoDB|\033[0;32m Pass \033[0m\n" >> log.txt
				else
					apt --fix-broken -y install
					if [[  $? == 0  ]]
					then
							sudo systemctl daemon-reload
							sudo systemctl start mongod
							sudo systemctl enable mongod
							echo -e "MongoDB|\033[0;32m Pass \033[0m\n" >> log.txt
					else
						echo -e "MongoDB|\033[0;31m Fail \033[0m\n" >> log.txt
					fi
				fi
			fi
		fi
	fi
fi
sudo rm mongodb-compass_1.28.4_amd64.deb

#MongoDB Compass
compassfile="./mongodb-compass_1.28.4_amd64.deb"
if [ -f $compassfile ]
then
	echo "file exists"
else
	wget https://downloads.mongodb.com/compass/mongodb-compass_1.28.4_amd64.deb
fi

sudo dpkg -i mongodb-compass_1.28.4_amd64.deb
if [[  $? == 0  ]]
then
	echo -e "Compass|\033[0;32m Pass \033[0m\n" >> log.txt
else
	sudo apt update
	sudo apt upgrade
	sudo apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		sudo dpkg -i mongodb-compass_1.28.4_amd64.deb
		if [[  $? == 0  ]]
		then
			echo -e "Compass|\033[0;32m Pass \033[0m\n" >> log.txt
		fi
	else
		echo -e "Compass|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#Insomnia
sudo snap install insomnia
if [[  $? == 0  ]]
then
	echo -e "Insomnia|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Insomnia|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Insomnia|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#Postman
sudo snap install postman
if [[  $? == 0  ]]
then
	echo -e "Postman|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Postman|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Postman|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#PostgresQL
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
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

#Figma
sudo snap install figma-linux
if [[ $? == 0  ]]
then
	echo -e "Figma|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "Figma|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Figma|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#Miro - "edge"/experimental release
sudo snap install --edge miro
if [[  $? == 0  ]]
then
	echo -e "Miro|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]
	then
		echo -e "Miro|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "Miro|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

#DrawIO - versatile UML software
sudo snap install drawio
if [[  $? == 0  ]]
then
	echo -e "DrawIO|\033[0;32m Pass \033[0m\n" >> log.txt
else
	apt --fix-broken -y install
	if [[  $? == 0  ]]
	then
		echo -e "DrawIO|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "DrawIO|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
fi

####################################### OTHER #########################################

#VirtualBox
read -p "Do you want to install Oracle Virtual Box? [y/n]: " virtualcont
if [[  $virtualcont == "y" ]]
then
	sudo apt-get -y install virtualbox
	if [[  $? == 0  ]]
	then
		echo -e "VirtualBox|\033[0;32m Pass \033[0m\n" >> log.txt
	else
		echo -e "VirtualBox|\033[0;31m Fail \033[0m\n" >> log.txt
	fi
else
	echo -e "VirtualBox|\033[0;33m Skip \033[0m\n" >> log.txt
fi

################################# CLEANUP ############################################
apt --fix-broken -y install
sudo apt autoremove
#################################### LOG ##############################################
echo "---------------------------------------------"
column log.txt -e -t -s "|"

echo -n "Review results and press enter to continue to ZSH install"

################################# ZSH ##############################################
read continueanswer
read -p "Install Oh-My-Zsh? [y/n]: " instzsh
if [[  $instzsh == "y"  ]]
then
	sleep 1s
	sudo apt-get -y install zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	exit 0
fi
echo -e "Oh-My-Zsh|\033[0;33m Skip \033[0m\n" >> log.txt
echo "---------------------------------------------"
echo "Complete - Log file can be found at ~/log.txt"
echo "---------------------------------------------"
exit 0
