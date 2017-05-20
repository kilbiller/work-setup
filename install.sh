# Windows user folder
#WINDOWS_USER_DIR="/mnt/c/Users/remy"

SCRIPT_USER=$(logname 2>/dev/null || echo $SUDO_USER)

apt-get update
apt-get install zsh -y

# Copy ssh keys when env variable is set
if [ -z "$WINDOWS_USER_DIR" ]; then
	cp -f "$WINDOWS_USER_DIR/.ssh/id_rsa" "$HOME/.ssh/id_rsa"
	cp -f "$WINDOWS_USER_DIR/.ssh/id_rsa.pub" "$HOME/.ssh/id_rsa.pub"
fi

# Create ssh config
rm -f "$HOME/.ssh/config"
cp -f "$PWD/config" "$HOME/.ssh/config"
chown -R "$SCRIPT_USER" "$HOME/.ssh"

# Hyper
rm -f "$HOME/.hyper.js"
cp -f "$PWD/.hyper.js" "$HOME/.hyper.js"
if ! [ -z "$WINDOWS_USER_DIR" ]; then
	sed -i -e "s/shell: 'bash.exe'/shell: ''/g" "$HOME/.hyper.js"
fi
chown "$SCRIPT_USER" "$HOME/.hyper.js"

mkdir -p "$HOME/console"
mkdir -p "$HOME/.zfunctions/"

# Pure
rm -rf "$HOME/console/pure"
git clone https://github.com/sindresorhus/pure.git "$HOME/console/pure"

rm -f "$HOME/.zfunctions/prompt_pure_setup"
ln -s "$HOME/console/pure/pure.zsh" "$HOME/.zfunctions/prompt_pure_setup"
rm -f "$HOME/.zfunctions/async"
ln -s "$HOME/console/pure/async.zsh" "$HOME/.zfunctions/async"

# zsh-syntax-hightlighting
rm -rf "$HOME/console/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/console/zsh-syntax-highlighting"

chown -R "$SCRIPT_USER" "$HOME/console"
chown -R "$SCRIPT_USER" "$HOME/.zfunctions"

# Create .zshrc
rm -f "$HOME/.zshrc"
cp "$PWD/.zshrc" "$HOME/.zshrc"
chown "$SCRIPT_USER" "$HOME/.zshrc"

# Launch zsh on startup
rm -f "$HOME/.bashrc"
cp "$PWD/.bashrc" "$HOME/.bashrc"
chown "$SCRIPT_USER" "$HOME/.bashrc"
