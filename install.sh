#!/bin/sh
set -e

DOWNLOAD_URL="https://github.com/kilbiller/work-setup/archive/master.tar.gz"
HYPER_VERSION=2.1.2

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

# Cleanup
rm -rf $TMPDIR
