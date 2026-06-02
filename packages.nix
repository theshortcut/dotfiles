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
    # Override `system` so dagger's callPackage doesn't read the deprecated
    # `pkgs.system` alias (warns under nixpkgs >= 2025-10-28). Remove this
    # `.override` once dagger fixes it upstream, or it will error.
    (daggerPkgs.dagger.override {
      system = pkgs.stdenv.hostPlatform.system;
    })
  ];
}
