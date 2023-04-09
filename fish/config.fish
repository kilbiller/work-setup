if status is-interactive
    # Commands to run in interactive sessions can go here
end

# kubernetes
fish_add_path $HOME/.krew/bin

# android sdk
set --export JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
set --export ANDROID_HOME $HOME/android-sdk
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/tools/bin
fish_add_path $ANDROID_HOME/cmdline-tools
fish_add_path $ANDROID_HOME/cmdline-tools/bin
fish_add_path $ANDROID_HOME/platform-tools

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH

# go
fish_add_path /usr/local/go/bin

# shortcuts
abbr -a -- cat batcat
abbr -a -- find fdfind
abbr -a -- ls exa
abbr -a -- vim nvim

status --is-interactive; and rbenv init - fish | source
