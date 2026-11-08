{ pkgs, lib, ... }:

let
  customPackages = import ../../packages/main/custom.nix {
    inherit pkgs lib;
  };
in
{
  programs.umbriel.enable = true;

  xdg.portal = {
    enable = true;

    extraPortals = [
      customPackages.strata
    ];

    config.umbriel = {
      default = [ "gtk" ];

      "org.freedesktop.impl.portal.FileChooser" = [
        "strata"
        "gtk"
      ];

      "org.freedesktop.impl.portal.ScreenCast" = [ "umbriel" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "umbriel" ];
    };
  };

  nix.settings = {
    extra-substituters = [
      "https://umbriel.cachix.org"
    ];

    extra-trusted-public-keys = [
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };
}
