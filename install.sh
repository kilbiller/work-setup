#!/bin/sh
set -e

DOWNLOAD_URL="https://github.com/kilbiller/work-setup/archive/master.tar.gz"
HYPER_VERSION=3.0.2
DOCKER_COMPOSE_VERSION=1.24.1
NODEJS_VERSION=10
PHP_VERSION=7.3
GIT_EMAIL=${GIT_EMAIL:-"peru.remy@gmail.com"}
GIT_NAME=${GIT_NAME:-"Rémy Peru"}

# Create temp directory
test -z "$TMPDIR" && TMPDIR="$(mktemp -d)"

# Download repo
if [ -z $DEV ]; then
	curl -sL $DOWNLOAD_URL -o /tmp/work-setup.tar.gz
	tar -xf /tmp/work-setup.tar.gz --strip-components=1 -C $TMPDIR
	rm -f /tmp/work-setup.tar.gz
else
	cp -r . $TMPDIR
fi

# Install fonts
mkdir -p $HOME/.fonts
cp -r $TMPDIR/fonts $HOME/.fonts
fc-cache -v

# Install zsh
export BINDIR=/usr/local/bin
sudo apt-get install -y zsh
curl -sL git.io/antibody | sudo -E sh -s
cp -rf $TMPDIR/.zshrc $HOME/.zshrc

# Install vim
sudo apt-get install -y vim

# Install git
sudo apt-get install -y git
cp -rf $TMPDIR/.gitconfig $HOME/.gitconfig
sed -E -i "s/(email =).*/\1 $GIT_EMAIL/" $HOME/.gitconfig
sed -E -i "s/(name =).*/\1 $GIT_NAME/" $HOME/.gitconfig

# Install hyper
curl -sL https://github.com/zeit/hyper/releases/download/${HYPER_VERSION}/hyper_${HYPER_VERSION}_amd64.deb -o $TMPDIR/hyper.deb
sudo apt-get install -y $TMPDIR/hyper.deb
cp -rf $TMPDIR/.hyper.js $HOME/.hyper.js

# Install google-chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update
sudo apt-get install -y google-chrome-stable

# Install vscode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > $TMPDIR/microsoft.gpg
sudo install -o root -g root -m 644 $TMPDIR/microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install -y code

# Install gpg
sudo apt-add-repository -y ppa:yubico/stable
sudo apt-get update
sudo apt-get install -y pcscd scdaemon gnupg2 pcsc-tools yubikey-manager
cp -rf $TMPDIR/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install nodejs
curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install -y yarn

# Install php
sudo add-apt-repository ppa:ondrej/php
sudo apt-get install -y php${PHP_VERSION} php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION}-mbstring php${PHP_VERSION}-xml php${PHP_VERSION}-zip

# Install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

# Install wine
curl -sS https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/winehq.list
sudo apt-get update
sudo apt install -y --install-recommends winehq-stable

# Install ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# Cleanup
rm -rf $TMPDIR
