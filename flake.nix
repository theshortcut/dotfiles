{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dagger = {
      url = "github:dagger/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, dagger, ... }:
    let
      arch = "aarch64-darwin";
      daggerPkgs = dagger.packages.${arch};
    in
    {
      defaultPackage.${arch} =
        home-manager.defaultPackage.${arch};

      homeConfigurations.clay =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${arch};
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit daggerPkgs; };
        };
    };
} 
