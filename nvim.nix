{ lib, pkgs, ...} : {
  xdg.configFile.nvim = {
    source = pkgs.fetchFromGitHub {
      owner = "theshortcut";
      repo = "neovim-config";
      rev = "7485f2ae787a7ed8dc9b2115d9a2e0a49f3f776c";
      sha256 = "1SNv+dZ65HyQpxF8Gu+oz/INOp87sPh8C6/uCYK9Om0=";
    };
  };
}
