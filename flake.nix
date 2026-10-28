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
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      mkHome =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            nix-index-database.homeModules.nix-index
            ./home.nix
            # Platform-specific bits; everything else in home.nix is shared.
            (if nixpkgs.lib.hasSuffix "darwin" system then ./darwin.nix else ./linux.nix)
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
        # `home-manager switch` tries `$USER@$(hostname)` first, then `$USER`.
        clay = mkHome "aarch64-darwin"; # default (Mac)
        "clay@framework" = mkHome "x86_64-linux"; # Arch laptop
        "clay@aarch64-darwin" = mkHome "aarch64-darwin";
        "clay@x86_64-darwin" = mkHome "x86_64-darwin";
        "clay@x86_64-linux" = mkHome "x86_64-linux";
        "clay@aarch64-linux" = mkHome "aarch64-linux";
      };
    };
}
