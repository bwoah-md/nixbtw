{ inputs, pkgs, customPackages, ... }:

let
  strata = inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default;
  rummage = inputs.rummage.packages.${pkgs.stdenv.hostPlatform.system}.rummage-with-media;
in
{
  programs.umbriel.enable = true;

  programs.rummage = {
    enable = true;
    package = rummage;
  };

  environment.systemPackages = [
    strata
  ];

  # FileManager1 D-Bus integration
  services.dbus.packages = [
    strata.fileManagerService
  ];

  # Disk management and encrypted volumes
  services.udisks2.enable = true;

  xdg.portal = {
    enable = true;

    extraPortals = [
      rummage
      strata.fileChooserPortal
      pkgs.xdg-desktop-portal-gtk
    ];

    config = {
      # System-wide file chooser preference
      common."org.freedesktop.impl.portal.FileChooser" = [
        "rummage"
        "strata"
        "gtk"
      ];

      # Umbriel-specific portal configuration
      umbriel = {
        "org.freedesktop.impl.portal.FileChooser" = [
          "rummage"
          "strata"
          "gtk"
        ];

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
      "https://strata.cachix.org"
    ];

    extra-trusted-public-keys = [
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      "strata.cachix.org-1:EFflsiJKJ9Zlsj11+oW9d4ib/KOUTf2oxilH/p2JJNo="
    ];
  };
}
