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

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-index-database,
      dagger,
      ...
    }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      mkHome =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            nix-index-database.homeModules.nix-index
            ./home.nix
          ];
          extraSpecialArgs = {
            daggerPkgs = dagger.packages.${system};
          };
        };
    in
    {
      packages = forAllSystems (system: {
        default = home-manager.packages.${system}.default;
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      homeConfigurations = {
        clay = mkHome "aarch64-darwin"; # default for this machine
        "clay@aarch64-darwin" = mkHome "aarch64-darwin";
        "clay@x86_64-darwin" = mkHome "x86_64-darwin";
      };
    };
}
