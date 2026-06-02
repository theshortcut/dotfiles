{ config, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Clayton Ferris";
        email = "cferris@gmail.com";
      };

      ui.default-command = "log";

      # Sign commits I author with the same SSH key git uses (see git.nix).
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
    };
  };
}
