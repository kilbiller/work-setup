source <(antibody init)

antibody bundle "
robbyrussell/oh-my-zsh path:plugins/ssh-agent
mafredri/zsh-async
sindresorhus/pure
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
"

## DOCKER CONFIG ##
# Use windows docker
export DOCKER_HOST=tcp://127.0.0.1:2375

# mount /mnt/c to /c if not already done
if [ ! -d "/c" ] || [ ! "$(ls -A /c)" ]; then
    echo "Requiring root password to $(tput setaf 6)mount --bind /mnt/c /c$(tput sgr 0)"
    sudo mkdir -p /c
    sudo mount --bind /mnt/c /c
fi
