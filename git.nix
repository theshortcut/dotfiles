{
  programs.git = {
    enable = true;
    ignores = [ ".DS_Store" ];
    signing = {
      format = "openpgp";
    };
    includes = [ { path = "~/.config/home-manager/gitconfig"; } ];
  };
}
