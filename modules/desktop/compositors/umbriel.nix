{ inputs, pkgs, customPackages, ... }:

let
  strata = inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default;
  flea = customPackages.flea;
in
{
  programs.umbriel.enable = true;

  environment.systemPackages = [
    strata
    flea
  ];

  # FileManager1 D-Bus integration
  services.dbus.packages = [
    strata.fileManagerService
    flea
  ];

  # Disk management and encrypted volumes
  services.udisks2.enable = true;

  xdg.portal = {
    enable = true;

    extraPortals = [
      strata.fileChooserPortal
      flea
      pkgs.xdg-desktop-portal-gtk
    ];

    config = {
      # System-wide file chooser preference
      common."org.freedesktop.impl.portal.FileChooser" = [
        "flea"
        "strata"
        "gtk"
      ];

      # Umbriel-specific portal configuration
      umbriel = {
        default = [
          "flea"
          "strata"
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
      "https://flea.cachix.org"
    ];

    extra-trusted-public-keys = [
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      "strata.cachix.org-1:EFflsiJKJ9Zlsj11+oW9d4ib/KOUTf2oxilH/p2JJNo="
      "flea.cachix.org-1:yxAlp6oY+Lfz4EsTDrKfz6NHasM02sTuGKe0JkSslH8="
    ];
  };
}
