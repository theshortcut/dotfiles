set -x GOPATH ~/.go
set -x NVM_SYMLINK_CURRENT true

function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

set -x PATH ~/bin $NVM_BIN /usr/local/bin /usr/local/sbin $GOPATH/bin $PATH

# SpinGo
bass source $HOME/.bash.d/ports.bash

alias g "git"
