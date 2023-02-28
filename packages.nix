{ pkgs, ... }: {
  home.packages = [
    pkgs.bat
    pkgs.coreutils
    pkgs.curl
    pkgs.delta
    pkgs.exa
    pkgs.fish
    pkgs.fnm
    pkgs.fzf
    pkgs.git
    pkgs.jq
    pkgs.neovim
    pkgs.ripgrep
    pkgs.starship
    pkgs.tmux
    pkgs.watchman
    pkgs.wget
  ];
}
