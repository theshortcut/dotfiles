{ lib, pkgs, ...} : {
  xdg.configFile.nvim = {
    source = pkgs.fetchFromGitHub {
      owner = "theshortcut";
      repo = "neovim-config";
      rev = "main";
      sha256 =  "IkbIGBQ1gWHmVouyg/8VEThm59+7Vc0KwuJzpuUX5Jo=";
    };
    recursive = true;
  };
}
