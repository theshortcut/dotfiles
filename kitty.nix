{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    font = {
      name = "Iosevka Nerd Font Mono";
      size = 14;
    };
    themeFile = "tokyo_night_night";
    settings = {
      hide_window_decorations = "titlebar-only";
      background_opacity = "0.98";
      shell = ".";
    };
  };
}
