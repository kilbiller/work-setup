# Use english
export LANG=en_US.UTF-8

# Enable autocompletions
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
zmodload -i zsh/complist

# Save history so we get auto suggestions
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# Options
setopt auto_cd # cd by typing directory name if it's not a command
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances
setopt interactive_comments # allow comments in interactive shells

# Improve autocompletion style
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Plugins
source <(antibody init)

export ZSH_CACHE_DIR=$HOME/.cache # Fix for some oh-my-zsh plugins

antibody bundle "
robbyrussell/oh-my-zsh path:plugins/ssh-agent
mafredri/zsh-async
sindresorhus/pure branch:main
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-autosuggestions
zsh-users/zsh-history-substring-search
zsh-users/zsh-completions
robbyrussell/oh-my-zsh path:plugins/aws
robbyrussell/oh-my-zsh path:plugins/composer
robbyrussell/oh-my-zsh path:plugins/yarn
robbyrussell/oh-my-zsh path:plugins/docker-compose
robbyrussell/oh-my-zsh path:plugins/kubectl
robbyrussell/oh-my-zsh path:plugins/minikube
robbyrussell/oh-my-zsh path:plugins/helm
"

# Keybindings

# Enable zsh-history-substring-search on linux & mac
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Fix delete key
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char
