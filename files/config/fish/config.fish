set -x GPG_TTY (tty)
set -x GOPATH ~/.go

set -x PATH ~/bin $HOME/.cargo/bin $GOPATH/bin $HOME/Library/Android/sdk/platform-tools $PATH

# Scala
set -x SBT_OPTS "-Xms512M -Xmx2G -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

# Android Studio
set -x ANDROID_HOME ~/Library/Android/sdk/

alias g "git"

function fco -d "Fuzzy-find and checkout a branch"
  git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
end

function fcoc -d "Fuzzy-find and checkout a commit"
  git log --pretty=oneline --abbrev-commit --reverse | fzf --tac +s -e | awk '{print $1;}' | read -l result; and git checkout "$result"
end

# Theme Config
set -g theme_powerline_fonts yes
set -g theme_nerd_fonts yes
set -g theme_color_scheme base16-dark
set -g theme_display_ruby no
set -g theme_display_docker_machine yes

# Editor
set -x EDITOR code
