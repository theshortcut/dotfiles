{
  home.username = "clay";
  home.homeDirectory = "/Users/clay";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  imports = [
    ./packages.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./jujutsu.nix
    ./nvim.nix
    ./starship.nix
    ./tmux.nix
    ./rest.nix
  ];
}
