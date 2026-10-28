{ lib, pkgs, ... }:
{
  home.homeDirectory = "/home/clay";

  # Non-NixOS distro (Arch): exposes Nix-installed apps, fonts and man pages
  # to the rest of the system via XDG_DATA_DIRS etc.
  targets.genericLinux.enable = true;

  # Ghostty's font isn't packaged by Arch's main repos; let Nix provide it.
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.nerd-fonts.iosevka
  ];

  # Arch's `nix` package ships its fish hook here instead of under
  # /nix/var/nix/profiles/default, and fish doesn't read /etc/profile.d.
  # mkBefore: Nix must be on PATH before fish.nix runs `fnm env`.
  programs.fish.loginShellInit = lib.mkBefore ''
    if test -e /etc/profile.d/nix-daemon.fish
      source /etc/profile.d/nix-daemon.fish
    end
  '';

  # Ghostty comes from pacman (package = null in ghostty.nix), which already
  # ships its systemd user unit; HM can't manage one without a package.
  programs.ghostty.systemd.enable = false;
}
