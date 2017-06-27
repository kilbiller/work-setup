# Windows user folder
#WINDOWS_USER_DIR="/mnt/c/Users/remy"

# Allow user to use sudo without having to enter a password everytime
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Ensure .ssh folder exists
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Copy ssh keys when env variable is set
if ! [ -z "$WINDOWS_USER_DIR" ]; then
	cp -f "$WINDOWS_USER_DIR/.ssh/id_rsa" "$HOME/.ssh/id_rsa"
	chmod 600 "$HOME/.ssh/id_rsa"
	cp -f "$WINDOWS_USER_DIR/.ssh/id_rsa.pub" "$HOME/.ssh/id_rsa.pub"
	chmod 644 "$HOME/.ssh/id_rsa.pub"
fi

# Create ssh config
yes | cp -rf "$PWD/config" "$HOME/.ssh/config"

# Hyper
if [ -z "$WINDOWS_USER_DIR" ]; then
	rm -f "$HOME/.hyper.js"
	cp -f "$PWD/.hyper.js" "$HOME/.hyper.js"
	sed -i -e "s/shell: 'bash.exe'/shell: ''/g" "$HOME/.hyper.js"
else
	rm -f "$WINDOWS_USER_DIR/.hyper.js"
	cp -f "$PWD/.hyper.js" "$WINDOWS_USER_DIR/.hyper.js"
fi

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

# Create .zshrc
yes | cp -rf "$PWD/.zshrc" "$HOME/.zshrc"

# Create .gitconfig
yes | cp -rf "$PWD/.gitconfig" "$HOME/.gitconfig"

# Launch zsh on startup
yes | cp -rf "$PWD/.bashrc" "$HOME/.bashrc"
