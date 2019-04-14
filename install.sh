#!/bin/sh
set -e

DOWNLOAD_URL="https://github.com/kilbiller/work-setup/archive/master.tar.gz"
test -z "$TMPDIR" && TMPDIR="$(mktemp -d)"

# Download repo
if [ -z $DEV ]; then
	rm -f /tmp/work-setup.tar.gz
	curl -sL $DOWNLOAD_URL -o /tmp/work-setup.tar.gz
	tar -xf /tmp/work-setup.tar.gz --strip-components=1 -C $TMPDIR
else
	cp -r . $TMPDIR
fi

# Install fonts
mkdir -p $HOME/.fonts
cp -r $TMPDIR/fonts $HOME/.fonts
fc-cache -f -v

# Install zsh
sudo apt-get install -y zsh
curl -sL git.io/antibody | sh -s
cp -rf $TMPDIR/.zshrc $HOME/.zshrc

# Install git
sudo apt-get install -y git
cp -rf $TMPDIR/.gitconfig $HOME/.gitconfig

# Install hyper
curl -sL https://github.com/zeit/hyper/releases/download/2.1.2/hyper_2.1.2_amd64.deb -o $TMPDIR/hyper.deb
sudo apt --fix-broken install -y $TMPDIR/hyper.deb
cp -rf $TMPDIR/.hyper.js $HOME/.hyper.js
