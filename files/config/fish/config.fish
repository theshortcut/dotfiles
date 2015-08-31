# Path to your oh-my-fish.
set -g OMF_PATH $HOME/.oh-my-fish

# Path to your oh-my-fish configuration.
set -g OMF_CONFIG $HOME/.config/omf

### Configuration required to load oh-my-fish ###
# Note: Only add configurations that are required to be set before oh-my-fish is loaded.
# For common configurations, we advise you to add them to your $OMF_CONFIG/init.fish file or
# to create a custom plugin instead.

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

set GOPATH ~/.go
set NVM_SYMLINK_CURRENT true

function nvm
  bass source ~/.nvm/nvm.sh ';' nvm $argv
end

nvm use --silent default

set PATH ~/bin $NVM_BIN /usr/local/bin /usr/local/sbin $GOPATH/bin $PATH

alias g "git"
