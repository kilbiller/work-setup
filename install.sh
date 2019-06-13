#!/bin/sh
set -e

DOWNLOAD_URL="https://github.com/kilbiller/work-setup/archive/master.tar.gz"
HYPER_VERSION=3.0.2
DOCKER_COMPOSE_VERSION=1.24.0
NODEJS_VERSION=10

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
export BINDIR=$TMPDIR/.bin
sudo apt-get install -y zsh
curl -sL git.io/antibody | sh -s
cp -rf $TMPDIR/.zshrc $HOME/.zshrc

# Install git
sudo apt-get install -y git
cp -rf $TMPDIR/.gitconfig $HOME/.gitconfig

# Install hyper
curl -sL https://github.com/zeit/hyper/releases/download/${HYPER_VERSION}/hyper_${HYPER_VERSION}_amd64.deb -o $TMPDIR/hyper.deb
sudo apt-get install -y $TMPDIR/hyper.deb
cp -rf $TMPDIR/.hyper.js $HOME/.hyper.js

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
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
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
sudo apt-get install yarn

# Cleanup
rm -rf $TMPDIR
