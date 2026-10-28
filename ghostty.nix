{
  programs.ghostty = {
    enable = true;
    # Ghostty is installed outside Nix (official DMG on macOS, pacman on
    # Arch, where a Nix-built GUI app would need nixGL), so manage config only.
    package = null;

    settings = {
      font-family = "Iosevka Nerd Font Mono";
      font-size = 14;

      adjust-cell-height = "20%";
      adjust-cursor-height = "20%";
      # adjust-cursor-thickness = "100%";
      # adjust-box-thickness = "100%";
      # adjust-underline-thickness = "400%";

      theme = "light:Catppuccin Latte,dark:Catppuccin Macchiato";
      window-theme = "system";
      background-opacity = 0.9;
      window-padding-x = 0;
      window-padding-y = 0;
    };
  };
}
