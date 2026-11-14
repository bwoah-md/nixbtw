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
    sonora.url = "github:sonorahq/sonora/stable";

    # ────── Discord Client ──────
    cressida.url = "github:Ly-sec/Cressida";

    # ────── Rayburst Download Manager ──────
    rayburst-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ────── Strata - File Manager ──────
    strata.url = "github:lgse/strata";

    # ────── Rummage - File Manager ──────
    rummage = {
      url = "github:barrulus/rummage";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ────── WinApps - Run Windows on Linux ──────
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, rayburst-nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # ────── Custom Packages ──────
      customPackages = {
        rayburst = rayburst-nixpkgs.legacyPackages.${system}.rayburst.overrideAttrs (oldAttrs: {
          buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
            pkgs.sqlite
          ];
        });
      };

    in
    {
      nixosConfigurations.nix = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs customPackages;
        };

        modules = [
          ./hosts/nix/imports.nix
          ./modules/packages/main/packages.nix
          ./modules/packages/options/integrations.nix

          # ────── Binary Caches ──────
          ({ ... }: {
            nix.settings = {

              # Setting this removes local compiles, set to 4 and 3600 to enable it again
              max-jobs = 0;
              narinfo-cache-negative-ttl = 0;

              trusted-users = [ "root" "icy" ];
              extra-substituters = [
                "https://cressida.cachix.org"
                "https://rayburst.cachix.org"
                "https://rummage.cachix.org"
                "https://sonora.cachix.org"
              ];

              extra-trusted-public-keys = [
                "cressida.cachix.org-1:yhfhTmhFIGnn+vdwFXxS7L9OrQJQ33+DkuTiZcQ4LgA="
                "rayburst.cachix.org-1:/g74/cQithzAXxw5uCfhYNH5pC3r2OSoXb/i1NZ23zU="
                "rummage.cachix.org-1:pgnbXs5DeHMKuQtyPiEzna+iFRLSPDppYJpE/Y6bIxw="
                "sonora.cachix.org-1:qbPeDsvZPbwUWHpQS5Oe0bjz5oHAVscHem+MCzwrc9Q="
              ];
            };
          })

          inputs.noctalia.nixosModules.default
          inputs.umbriel.nixosModules.default
          inputs.helium-flake.nixosModules.default
          inputs.rummage.nixosModules.default
        ];
      };

      # Custom and External Packages
      packages.${system} = customPackages // {
        cressida = inputs.cressida.packages.${system}.default;
        rummage = inputs.rummage.packages.${system}.rummage-with-media;
      };
    };
}
