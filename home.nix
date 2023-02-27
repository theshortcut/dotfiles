{ config, pkgs, lib, ...}: {
  home.username = "cferris";
  home.homeDirectory = "/Users/cferris";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  imports = [ ./packages.nix ./fish.nix ./git.nix ./starship.nix ];
}
