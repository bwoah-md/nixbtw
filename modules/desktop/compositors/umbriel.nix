{ inputs, pkgs, ... }:

let
  strata = inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  programs.umbriel.enable = true;

  environment.systemPackages = [ strata ];

  # FileManager1 D-Bus integration
  services.dbus.packages = [
    strata.fileManagerService
  ];

  # Disk management and encrypted volumes
  services.udisks2.enable = true;

  xdg.portal = {
    enable = true;

    extraPortals = [
      strata.fileChooserPortal
      pkgs.xdg-desktop-portal-gtk
    ];

    config = {
      # System-wide file chooser preference
      common."org.freedesktop.impl.portal.FileChooser" = [
        "strata"
        "gtk"
      ];

      # Umbriel-specific portal configuration
      umbriel = {
        default = [ "gtk" ];

        "org.freedesktop.impl.portal.ScreenCast" = [
          "umbriel"
        ];

        "org.freedesktop.impl.portal.Screenshot" = [
          "umbriel"
        ];
      };
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
