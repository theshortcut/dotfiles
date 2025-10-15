{ config, pkgs, lib, ... }:

let
  inherit (lib.generators) toKeyValue mkKeyValueDefault;

in {
  xdg.configFile."ghostty/config".text = toKeyValue { mkKeyValue = mkKeyValueDefault { } " = "; } {
    font-family = "Iosevka Nerd Font Mono";
    font-size = 14;
    font-thicken = true;

    adjust-cell-height = "20%";
    adjust-cursor-height = "20%";
    # adjust-cursor-thickness = "100%";
    # adjust-box-thickness = "100%";
    # adjust-underline-thickness = "400%";

    theme = "light:Catppuccin Latte,dark:Catppuccin Macchiato";
    window-theme = "system";
    window-colorspace = "display-p3";
    background-opacity = 0.9;
    background-blur-radius = 10;
    window-padding-x = 0;
    window-padding-y = 0;

    auto-update = "download";
  };
}
