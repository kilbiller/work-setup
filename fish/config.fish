if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path $HOME/.krew/bin

set --export JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
set --export ANDROID_HOME $HOME/android-sdk
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/tools/bin
fish_add_path $ANDROID_HOME/cmdline-tools
fish_add_path $ANDROID_HOME/cmdline-tools/bin
fish_add_path $ANDROID_HOME/platform-tools