#!/bin/sh
set -e

DOWNLOAD_URL="https://github.com/kilbiller/work-setup/archive/master.tar.gz"
HYPER_VERSION=3.0.2
DOCKER_COMPOSE_VERSION=1.28.6
NODEJS_VERSION=14
PHP_VERSION=7.4
KUBERNETES_VERSION=1.17.0

# Create temp directory
test -z "$TMPDIR" && TMPDIR="$(mktemp -d)"

# Download repo
if [ -z "$DEV" ]; then
  curl -sL $DOWNLOAD_URL -o /tmp/work-setup.tar.gz
  tar -xf /tmp/work-setup.tar.gz --strip-components=1 -C "$TMPDIR"
  rm -f /tmp/work-setup.tar.gz
else
  cp -r . "$TMPDIR"
fi

# Use sudo without filling password everytime
echo "$USER ALL=(ALL) NOPASSWD: ALL" | (sudo su -c 'EDITOR="tee" visudo -f /etc/sudoers.d/auto_sudo')

# Install fonts
sudo apt-get install -y fontconfig
mkdir -p "$HOME"/.fonts
cp -r "$TMPDIR"/fonts "$HOME"/.fonts
fc-cache -v

# Install zsh & plugin manager
sudo apt-get install -y zsh
curl -sfL git.io/antibody | sudo -E sh -s - -b /usr/local/bin

cp -rf "$TMPDIR"/.zshrc "$HOME"/.zshrc

# Change default shell to zsh
sudo chsh $USER -s $(which zsh)

# vim
sudo apt-get install -y vim

# git
sudo apt-get install -y git

# Set git config if not already
if test -z $(git config --global --get user.email); then
  echo "What is your git email ?"
  read git_email
  echo "What is your git name ?"
  read git_name

  git config --global user.email $git_email
  git config --global user.name $git_name
fi
git config --global core.editor vim

# gnome terminal (ubuntu default)
curl -sL https://raw.githubusercontent.com/arcticicestudio/nord-gnome-terminal/develop/src/nord.sh | bash

set_default_profile_by_name() {
  local name=$1
  local profiles="$(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "[]\',")"
  for uuid in "$profiles"; do
    if [[ "$(gsettings get org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${uuid}"/ visible-name)" == "'$name'" ]]; then
      gsettings set org.gnome.Terminal.ProfilesList default "${uuid}"
	    return 0
    fi
  done
}

set_default_profile_by_name "Nord"
gsettings set org.gnome.Terminal.Legacy.Settings headerbar false
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false

# Profile settings
GNOME_TERMINAL_PROFILE=`gsettings get org.gnome.Terminal.ProfilesList default | awk -F \' '{print $2}'`
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ font 'Hack 14'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ use-system-font false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ audible-bell false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ scrollbar-policy 'never'

# Alternative option (load entire config as file)
#cat <<EOT | dconf load /org/gnome/terminal/
#[legacy]
#default-show-menubar=false
#headerbar=@mb false
#schema-version=uint32 3
#
#[legacy/profiles:]
#default='09dc1416-e8bd-43c6-a2ad-c37c017d3da2'
#list=['09dc1416-e8bd-43c6-a2ad-c37c017d3da2']
#
#[legacy/profiles:/:09dc1416-e8bd-43c6-a2ad-c37c017d3da2]
#audible-bell=false
#background-color='#2E3440'
#bold-color='#D8DEE9'
#bold-color-same-as-fg=true
#cursor-background-color='rgb(216,222,233)'
#cursor-colors-set=true
#cursor-foreground-color='rgb(59,66,82)'
#font='Hack 14'
#foreground-color='#D8DEE9'
#highlight-background-color='rgb(136,192,208)'
#highlight-colors-set=true
#highlight-foreground-color='rgb(46,52,64)'
#nord-gnome-terminal-version='0.1.0'
#palette=['#3B4252', '#BF616A', '#A3BE8C', '#EBCB8B', '#81A1C1', '#B48EAD', '#88C0D0', '#E5E9F0', '#4C566A', '#BF616A', '#A3BE8C', '#EBCB8B', '#81A1C1', '#B48EAD', '#8FBCBB', '#ECEFF4']
#scrollbar-policy='never'
#use-system-font=false
#use-theme-background=false
#use-theme-colors=false
#use-theme-transparency=false
#use-transparent-background=false
#visible-name='Nord'
#EOT

# hyper
echo "Installing hyper..."
if test "$HYPER_VERSION" != $(hyper version) ; then
  curl -L https://github.com/zeit/hyper/releases/download/${HYPER_VERSION}/hyper_${HYPER_VERSION}_amd64.deb -o "$TMPDIR"/hyper.deb
  sudo apt-get install -y "$TMPDIR"/hyper.deb
  echo "done"
else
  echo "already installed"
fi
cp -rf "$TMPDIR"/.hyper.js "$HOME"/.hyper.js
echo "hyper configuration updated"

# google-chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update
sudo apt-get install -y google-chrome-stable

# vscode
if ! grep -q microsoft /proc/version; then # Not in wsl
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >"$TMPDIR"/microsoft.gpg
  sudo install -o root -g root -m 644 "$TMPDIR"/microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt-get update
  sudo apt-get install -y code
fi

# gpg
sudo apt-add-repository -y --update ppa:yubico/stable
sudo apt-get install -y pcscd scdaemon gnupg2 pcsc-tools yubikey-manager
mkdir -p "$HOME"/.gnupg
cp -rf "$TMPDIR"/gpg-agent.conf "$HOME"/.gnupg/gpg-agent.conf

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker "$USER"

# docker-compose
echo "Installing docker-compose..."
if test "$DOCKER_COMPOSE_VERSION" != $(docker-compose version --short); then
sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-"$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
  sudo chmod +x /usr/local/bin/docker-compose
  echo "done"
else
  echo "already installed"
fi

# kubectl
echo "Installing kubectl..."
if test "v${KUBERNETES_VERSION}" != $(kubectl version --client --short | awk '{print $3}'); then
  sudo curl -L "https://dl.k8s.io/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
  sudo chmod +x /usr/local/bin/kubectl
  echo "done"
else
  echo "already installed"
fi

# kustomize
echo "Installing kustomize..."
curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases |
  grep browser_download |
  grep linux_amd64 |
  cut -d '"' -f 4 |
  grep /kustomize/v |
  sort |
  tail -n 1 |
  xargs curl -L -o "$TMPDIR"/kustomize.tar.gz
tar xzf "$TMPDIR"/kustomize.tar.gz -C "$TMPDIR"
chmod +x "$TMPDIR"/kustomize
sudo mv "$TMPDIR"/kustomize /usr/local/bin/kustomize

# minikube
echo "Installing minikube..."
latest_version=$(curl -s https://api.github.com/repos/kubernetes/minikube/releases |
 grep browser_download |
 grep minikube-linux-amd64 |
 cut -d '"' -f 4 |
 head -n 1 |
 awk -F'/' '{print $8}'
)
if test $latest_version != $(minikube version --short | awk '{print $3}'); then
curl -LO "https://storage.googleapis.com/minikube/releases/${latest_version}/minikube-linux-amd64" &&
  sudo install minikube-linux-amd64 /usr/local/bin/minikube &&
  rm minikube-linux-amd64
  echo "done"
else
  echo "already installed"
fi

# nodejs
echo "Installing nodejs..."
curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | sudo -E bash -
sudo apt-get install -y nodejs

# yarn
echo "Installing yarn..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install -y yarn

# php
echo "Installing php..."
sudo add-apt-repository -y --update ppa:ondrej/php
sudo apt-get install -y php${PHP_VERSION} php${PHP_VERSION}-dev php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION}-mbstring php${PHP_VERSION}-xml php${PHP_VERSION}-zip

# composer
echo "Installing composer..."
php -r "copy('https://getcomposer.org/installer', '$TMPDIR/composer-setup.php');"
sudo php "$TMPDIR"/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# ansible
echo "Installing ansible..."
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# Cleanup
rm -rf "$TMPDIR"
