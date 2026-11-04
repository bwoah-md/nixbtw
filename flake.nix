{
  description = "NixOS Flake Configuration for icy@nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    helium-flake = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sonora.url = "github:sonorahq/sonora";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel.url = "github:noctalia-dev/umbriel/cachix";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      customPackages = import ./modules/packages/main/custom.nix {
        inherit pkgs;
        lib = pkgs.lib;
      };
    in
    {
      nixosConfigurations.nix = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./hosts/nix/imports.nix
          ./modules/packages/main/packages.nix
          ./modules/packages/options/integrations.nix
          inputs.noctalia.nixosModules.default
          inputs.umbriel.nixosModules.default
          inputs.helium-flake.nixosModules.default
        ];
      };

      # Custom Packages
      packages.${system} = customPackages;
    };
}
