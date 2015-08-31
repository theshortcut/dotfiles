# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Path to your custom folder (default path is ~/.oh-my-fish/custom)
#set fish_custom $HOME/dotfiles/oh-my-fish

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

# Custom plugins and themes may be added to ~/.oh-my-fish/custom
# Plugins and themes can be found at https://github.com/oh-my-fish/
Theme 'bobthefish'
Plugin 'theme'

set GOPATH ~/.go
set NVM_SYMLINK_CURRENT true

function nvm
  bass source ~/.nvm/nvm.sh ';' nvm $argv
end

nvm use --silent default

set PATH ~/bin $NVM_BIN /usr/local/bin /usr/local/sbin $GOPATH/bin $PATH


alias g "git"

set TF_ALIAS fuck
function fuck -d 'Correct your previous console command'
    set -l exit_code $status
    set -l eval_script (mktemp 2>/dev/null ; or mktemp -t 'thefuck')
    set -l fucked_up_commandd $history[1]
    thefuck $fucked_up_commandd > $eval_script
    . $eval_script
    rm $eval_script
    if test $exit_code -ne 0
        history --delete $fucked_up_commandd
    end
end
