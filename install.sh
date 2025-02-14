#!/bin/sh
set -e

DOWNLOAD_URL="https://github.com/kilbiller/work-setup/archive/master.tar.gz"
NODEJS_VERSION=22
PHP_VERSION=8.3

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

# ssh
mkdir -p "$HOME/.ssh"
cp "$TMPDIR"/ssh/config "$HOME/.ssh/config"

# Install fish
sudo add-apt-repository -y --update ppa:fish-shell/release-3
sudo apt install fish
mkdir -p "$HOME/.config/fish"
cp "$TMPDIR"/fish/config.fish "$HOME/.config/fish/config.fish"
cp "$TMPDIR"/fish/fish_plugins "$HOME/.config/fish/fish_plugins"
cp "$TMPDIR"/fish/functions/fish_user_key_bindings.fish "$HOME/.config/fish/functions/fish_user_key_bindings.fish"

# Change default shell
sudo chsh "$USER" -s "$(which fish)"

# Neovim
sudo add-apt-repository -y --update ppa:neovim-ppa/stable
sudo apt-get install -y neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
mkdir -p "$HOME/.config/nvim"
cp "$TMPDIR"/neovim/init.vim "$HOME/.config/nvim/init.vim"

# git
sudo apt-get install -y git

# Set git config if not already
if test -z "$(git config --global --get user.email)"; then
  echo "What is your git email ?"
  read -r git_email
  echo "What is your git name ?"
  read -r git_name

  git config --global user.email "$git_email"
  git config --global user.name "$git_name"
fi
git config --global core.editor nvim

# bat
sudo apt-get install -y bat

# eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# fd
sudo apt install -y fd-find

# vscode
if ! grep -q microsoft /proc/version; then # Not in wsl
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >"$TMPDIR"/microsoft.gpg
  sudo install -o root -g root -m 644 "$TMPDIR"/microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt-get update
  sudo apt-get install -y code
fi

# nodejs
echo "Installing node-${NODEJS_VERSION}..."
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
echo "fnm env --use-on-cd --shell fish | source" > "$HOME/.config/fish/conf.d/fnm.fish"
fnm install ${NODEJS_VERSION}

# php
echo "Installing php${PHP_VERSION}..."
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
