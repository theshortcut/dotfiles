set fisher_home ~/src/fisherman
set fisher_config ~/.config/fisherman
source $fisher_home/config.fish

set GOPATH ~/.go
set NVM_SYMLINK_CURRENT true

function nvm
  bass source ~/.nvm/nvm.sh ';' nvm $argv
end

nvm use --silent default

set PATH ~/bin $NVM_BIN /usr/local/bin /usr/local/sbin $GOPATH/bin $PATH

# SpinGo
for file in $HOME/.bash.d/*.bash
  bass source $file
end

alias g "git"
