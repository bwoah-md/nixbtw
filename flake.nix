{
  description = "NixOS Flake Configuration for icy@nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    helium-flake = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    surge.url = "github:SurgeDM/Surge/08d09d11199acf6082a89c4da0d19a04749de997";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel.url = "github:noctalia-dev/umbriel/cachix";

    zapfast = {
      url = "github:crmne/zapfast";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    serein = {
      url = "github:ViceVerse-cz/Serein";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      customPackages = import ./modules/packages/custom.nix {
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
          ./modules/packages/cachix.nix
          inputs.noctalia.nixosModules.default
          inputs.umbriel.nixosModules.default
          inputs.helium-flake.nixosModules.default
        ];
      };

      # Custom Packages
      packages.${system} = customPackages;
    };
}
