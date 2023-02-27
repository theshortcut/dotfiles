{ pkgs, ... }: {
  home.packages = [
    pkgs.fish
    pkgs.fnm
    pkgs.git
    pkgs.jq
    pkgs.starship
    pkgs.tmux
  ];
}
