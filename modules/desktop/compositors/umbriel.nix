{ inputs, lib, pkgs, customPackages, ... }:

{
  programs.umbriel.enable = true;

  programs.rummage = {
    enable = true;

    preview = {
      thumbnails = true;
      pdf = true;
    };

    filePicker.enable = true;
  };

  environment.systemPackages = [
    inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # FileManager1 D-Bus integration
  services.dbus.packages = [
    inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.portal = {
    enable = true;

    extraPortals = [
      inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default.fileChooserPortal
      pkgs.xdg-desktop-portal-gtk
    ];

    config = {
      # System-wide file chooser preference
      common."org.freedesktop.impl.portal.FileChooser" = [
        "luciole"
        "rummage"
        "strata"
        "gtk"
      ];

      # Umbriel-specific portal configuration
      umbriel = {
        "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [
          "luciole"
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
      "https://rummage-fm.cachix.org"
      "https://luciole.cachix.org"
    ];

    extra-trusted-public-keys = [
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      "strata.cachix.org-1:EFflsiJKJ9Zlsj11+oW9d4ib/KOUTf2oxilH/p2JJNo="
      "rummage-fm.cachix.org-1:fhPhaCttVfPBS/i//+Z+6Ch0xdxj9g94eZdQ5m6mlwA="
      "luciole.cachix.org-1:YEloCAPjicQ2MSjXPpsj4qz7A6rCaIWQTJU6wXYhhSo="
    ];
  };
}
