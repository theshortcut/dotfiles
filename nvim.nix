{ lib, pkgs, ...} : {
  xdg.configFile.nvim = {
    source = pkgs.fetchFromGitHub {
      owner = "theshortcut";
      repo = "neovim-config";
      rev = "853e8ad92b436e6045ead6b154411c648ca3538b";
      sha256 =  "yjq2QRJiUe69yRXakIKwIW8k+R4H1LYQXYZugdGVaFk=";
    };
  };
}
