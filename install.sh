# Windows user folder
#WINDOWS_USER_DIR="/mnt/c/Users/remy"

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

# Create .vimrc
yes | cp -rf "$PWD/.vimrc" "$HOME/.vimrc"

# Hyper
if [ -z "$WINDOWS_USER_DIR" ]; then
	rm -f "$HOME/.hyper.js"
	cp -f "$PWD/.hyper.js" "$HOME/.hyper.js"
	sed -i -e "s/shell: 'wsl.exe'/shell: ''/g" "$HOME/.hyper.js"
else
	rm -f "$WINDOWS_USER_DIR/.hyper.js"
	cp -f "$PWD/.hyper.js" "$WINDOWS_USER_DIR/.hyper.js"
fi

# Create .zshrc
yes | cp -rf "$PWD/.zshrc" "$HOME/.zshrc"

# Create .gitconfig
yes | cp -rf "$PWD/.gitconfig" "$HOME/.gitconfig"
