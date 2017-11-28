# Work setup

# Windows

* Enable bash for windows
* Install Hyper
* Add ssh key
* Install meslo 1.2.1 LG DZ medium
  https://github.com/andreberg/Meslo-Font/raw/master/dist/v1.2.1/Meslo%20LG%20DZ%20v1.2.1.zip

```
rm -rf ~/work-setup && sudo apt-get update && sudo apt-get install zsh -y && chsh -s $(which zsh) && git clone https://github.com/kilbiller/work-setup.git ~/work-setup && cd ~/work-setup && chmod u+x install.sh && WINDOWS_USER_DIR="/mnt/c/Users/remy" ./install.sh
```

# Ubuntu

## Prerequisites

* Install Hyper
* Add ssh key

```
rm -rf ~/work-setup && sudo apt-get update && sudo apt-get install zsh -y && git clone https://github.com/kilbiller/work-setup.git ~/work-setup && cd ~/work-setup && chmod u+x install.sh && ./install.sh
```
