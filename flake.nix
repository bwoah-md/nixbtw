{
  description = "NixOS Flake Configuration for icy@nix";

  inputs = {
    # ────── NixPackages ──────
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # ────── Noctalia ──────
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    # ────── Umbriel ──────
    umbriel.url = "github:noctalia-dev/umbriel/cachix";

    # ────── Helium Browser ──────
    helium-flake = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ────── Music Client ──────
    sonora.url = "github:sonorahq/sonora";

    # ────── Discord Client ──────
    cressida.url = "github:Ly-sec/Cressida";

    # ────── Strata - File Manager ──────
    strata.url = "github:lgse/strata/9fb7a36ad4352337f3ada0d43710dc6d4ae838b9";

    # ────── WinApps - Run Windows on Linux ──────
    winapps = {
      url = "github:winapps-org/winapps";
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

          # ────── Binary Caches ──────
          ({ ... }: {
            nix.settings = {
              trusted-users = [ "root" "icy" ];
              extra-substituters = [
                "https://cressida.cachix.org"
                "https://misterdownloadmanager.cachix.org"
              ];

              extra-trusted-public-keys = [
                "cressida.cachix.org-1:yhfhTmhFIGnn+vdwFXxS7L9OrQJQ33+DkuTiZcQ4LgA="
                "misterdownloadmanager.cachix.org-1:CZkwhLDHdo/WBrr4OrYsYXPwVxC1VYDFQQA75h+Axv8="
              ];
            };
          })

          inputs.noctalia.nixosModules.default
          inputs.umbriel.nixosModules.default
          inputs.helium-flake.nixosModules.default
        ];
      };

      # Custom and External Packages
      packages.${system} = customPackages // {
        cressida = inputs.cressida.packages.${system}.default;
      };
    };
}
