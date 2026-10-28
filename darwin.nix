{ lib, pkgs, ... }:
{
  home.homeDirectory = "/Users/clay";

  home.packages = [
    pkgs.coreutils # GNU coreutils over the BSD ones
    pkgs.colima
    pkgs.docker
  ];

  programs.fish = {
    # mkBefore: Nix must be on PATH before fish.nix runs `fnm env`.
    loginShellInit = lib.mkBefore ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end
    '';
    shellInit = ''
      if test -d /opt/homebrew/bin
        fish_add_path /opt/homebrew/bin
      end
    '';
  };

  # macOS-only Ghostty options.
  programs.ghostty.settings = {
    font-thicken = true;
    window-colorspace = "display-p3";
    background-blur-radius = 10;
    auto-update = "download";
  };
}
