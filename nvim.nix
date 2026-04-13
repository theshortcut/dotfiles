{ config, ... }:
{
  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/neovim-config/";
    recursive = true;
  };
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
  };
}
