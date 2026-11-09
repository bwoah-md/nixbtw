{ inputs, pkgs, ... }:

let
  strata = inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  programs.umbriel.enable = true;

  environment.systemPackages = [ strata ];

  services.dbus.packages = [ strata.fileManagerService ];

  xdg.portal = {
    enable = true;

    extraPortals = [
      strata.fileChooserPortal
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
      "https://stratafiles.cachix.org"
    ];

    extra-trusted-public-keys = [
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      "stratafiles.cachix.org-1:1027HWSwpIo9qBk4myf9yuCkFuvq3h8aAeLPHWrEslM="
    ];
  };
}
