{ pkgs, daggerPkgs, ... }:
{
  home.packages = [
    # Shell & prompt
    pkgs.fish
    pkgs.starship
    pkgs.tmux

    # CLI utilities
    pkgs.bat
    pkgs.coreutils
    pkgs.curl
    pkgs.eza
    pkgs.fzf
    pkgs.jq
    pkgs.ripgrep
    pkgs.wget

    # Git & version control
    pkgs.delta
    pkgs.gh
    pkgs.git
    pkgs.gnupg
    pkgs.jujutsu
    pkgs.lazygit

    # Containers & CI
    pkgs.act
    pkgs.colima
    pkgs.docker

    # Language toolchains & package managers
    pkgs.bun
    pkgs.fnm
    pkgs.pnpm-shell-completion
    pkgs.rustup
    pkgs.tenv
    pkgs.uv

    # Build / task runners
    pkgs.just

    # Nix tooling
    pkgs.nil
    pkgs.nixd
    pkgs.nixfmt
  ]
  ++ [
    daggerPkgs.dagger
  ];
}
