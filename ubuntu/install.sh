# Windows user folder
WINDOWS_USER_DIR="/mnt/c/Users/remy"

apt-get update
apt-get install zsh -y

# Copy ssh keys
cp -f "$WINDOWS_USER_DIR/.ssh/id_rsa" "$HOME/.ssh/id_rsa"
cp -f "$WINDOWS_USER_DIR/.ssh/id_rsa.pub" "$HOME/.ssh/id_rsa.pub"

# Create ssh config
rm -f "$HOME/.ssh/config"
cp -f "$PWD/config" "$HOME/.ssh/config"

mkdir -p "$HOME/console"

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
