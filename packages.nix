{ pkgs, daggerPkgs, ... }:
{
  home.packages = [
    pkgs.act
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
    pkgs.jujutsu
    pkgs.jq
    pkgs.lazygit
    pkgs.nil
    pkgs.nixd
    pkgs.pnpm-shell-completion
    pkgs.ripgrep
    pkgs.rustup
    pkgs.starship
    pkgs.tmux
    pkgs.tenv
    pkgs.uv
    pkgs.wget
  ]
  ++ [
    daggerPkgs.dagger
  ];
}
