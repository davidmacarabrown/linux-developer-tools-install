# Software Development Tools Installer Script for Ubuntu LTS v20.04.3

## Overview

This script is designed to provide a largely unattended install procedure for various popular development tools. It installs various IDEs, Git, and a selection of popular languages and databases. Some design tools and common workspaces are also included (Zoom... Slack). This is a first draft and is by no means complete and has been tested on my personal machine running the aforementioned version of Ubuntu only. Your mileage may vary.

This script is provided without warranty of ANY KIND. Please review the script for yourself before running it on your machine.

## How To Use This Script

1. Download the script file to your root directory. The path of your file should be: ~/install_script.sh
2. Open the terminal, navigate to the same folder.  
3. At this point it is also a good idea to update package managers and currently installed packages.  

To do this enter:

`sudo apt-get update && sudo apt-get upgrade`  

then:  

`sudo snap refresh`  

It is a good idea to reboot your computer before continuing.  
4. Before running the file in the terminal, we have to make it executable. To do this enter:  
`chmod +x install_script.sh`  
and press enter. The file is now executable.  
5. Before running the script, open it in a text editor of your choice and take a look at the contents. Some options are commented out by default, and you can comment out anything you wish to skip for now. You can re-run the script later to install them, or install them manually.  
6. To Run the script, navigate to the root folder in the terminal and enter:  
`sh install_script.sh`  
7. Get something to drink, and follow any prompts in the terminal for the optional installs.
8. Feel free to add to the script anything you find useful for the future.

## Included Items

### Workspaces

- Zoom
- Slack
- Discord

### Version

- Git

### IDEs & Editors

- Atom
- VSCode
- IntelliJ Community Edition
- Android Studio
- PyCharm Community Edition
- Thonny (lightweight IDE for MicroPython)

### Languages

- Python3 (Included as standard in Ubuntu)
- NodeJS & NPM
- Java JDK 8 (customise version as you see fit)

### Database

- MongoDB & MongoDB Compass
- PostgresQL

### API Testing

- Insomnia
- Postman

### Design Tools

- Figma
- Miro
- DrawIO

### Optional

- Mono C# IDE (Commented out in the file by default)
- Oracle VirtualBox
- Oh-My-Zsh terminal shell
- Local time adjustment (useful when dual-booting to avoid clock sync problems in Windows)

### Other

- Curl
- XClip (useful for copying to the clipboard from terminal e.g. for pasting SSH key to Github account)
