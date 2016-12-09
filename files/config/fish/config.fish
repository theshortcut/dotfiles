set -x GOPATH ~/.go
set -x NVM_SYMLINK_CURRENT true

set -x PATH ~/bin $NVM_BIN /usr/local/bin $GOPATH/bin $PATH

# Scala
set -x SBT_OPTS "-Xms512M -Xmx2G -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

# NVM
nvm use default --silent

# Android Studio
set -x ANDROID_HOME ~/Library/Android/sdk/
set -x PATH ~/Library/Android/sdk/platform-tools/ $PATH

# SpinGo
bass source $HOME/.bash.d/ports.bash

alias g "git"

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
