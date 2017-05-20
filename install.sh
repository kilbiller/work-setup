# Windows user folder
#WINDOWS_USER_DIR="/mnt/c/Users/remy"

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
git@github.com:kilbiller/work-setup.git
mkdir -p "$HOME/console"
mkdir -p "$HOME/.zfunctions/"

# Hyper
rm -f "$HOME/.hyper.js"
cp -f "$PWD/.hyper.js" "$HOME/.hyper.js"

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
rm -f "$HOME/.zshrc"
cp "$PWD/.zshrc" "$HOME/.zshrc"

# Launch zsh on startup
rm -f "$HOME/.bashrc"
cp "$PWD/.bashrc" "$HOME/.bashrc"
