{ pkgs, ... }: {
  home.packages = [
    pkgs.bat
    pkgs.exa
    pkgs.fish
    pkgs.fnm
    pkgs.git
    pkgs.jq
    pkgs.neovim
    pkgs.starship
    pkgs.tmux
  ];
}
