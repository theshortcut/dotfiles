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
    pkgs.rustup
    pkgs.starship
    pkgs.tmux
    pkgs.wget
  ];
}
