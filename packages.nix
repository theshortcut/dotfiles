{ pkgs, inputs, daggerPkgs, ... }: {
  home.packages = [
    pkgs.bat
    pkgs.coreutils
    pkgs.colima
    pkgs.curl
    pkgs.delta
    pkgs.docker
    pkgs.eza
    pkgs.fish
    pkgs.fnm
    pkgs.fzf
    pkgs.git
    pkgs.gnupg
    pkgs.jq
    pkgs.ripgrep
    pkgs.rustup
    pkgs.starship
    pkgs.tmux
    pkgs.wget
  ] ++ [
    daggerPkgs.dagger
  ];
}
