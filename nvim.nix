{ lib, pkgs, ...} : {
  xdg.configFile.nvim = {
    source = pkgs.fetchFromGitHub {
      owner = "theshortcut";
      repo = "neovim-config";
      rev = "cee65bb10b7d49d2563ead7068e2f8ae567c40fa";
      sha256 = "f/Jt87pxC3aMqe3BTrmMCZlIGSURjyeoxyCYojSsLbE=";
    };
  };
}
