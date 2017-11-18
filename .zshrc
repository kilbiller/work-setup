env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ;
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running

agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

fpath=( "$HOME/.zfunctions" $fpath )
autoload -U promptinit; promptinit
prompt pure

source "$HOME/console/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

## DOCKER CONFIG ##
# Use windows docker
export DOCKER_HOST=tcp://127.0.0.1:2375

# mount /mnt/c to /c if not already done
if [ ! -d "/c" ] || [ ! "$(ls -A /c)" ]; then
    echo "Requiring root password to $(tput setaf 6)mount --bind /mnt/c /c$(tput sgr 0)"
    sudo mkdir -p /c
    sudo mount --bind /mnt/c /c
fi
