{
  programs.git = {
    enable = true;
    ignores = [".DS_Store"];
    includes = [{ path = "~/.config/home-manager/gitconfig"; }];
  };
}
