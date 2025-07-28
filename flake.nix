{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    dagger = {
      url = "github:dagger/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-index-database, dagger, ... }:
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
          modules = [ nix-index-database.homeModules.nix-index ./home.nix ];
          extraSpecialArgs = { inherit daggerPkgs; };
        };
    };
} 
