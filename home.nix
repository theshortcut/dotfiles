{ pkgs, ...}: {
  home.username = "cferris";
  home.homeDirectory = "/Users/cferris";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    includes = [{ path = "~/.config/nixpkgs/gitconfig"; }];
  };
}
