{ inputs, pkgs, lib, ... }:

let
  customPackages = import ../packages/custom.nix {
    inherit pkgs lib;
  };
in

{
  imports = [
    inputs.umbriel.nixosModules.default
    ./greeter.nix
    ./theming.nix
  ];

  programs.umbriel = {
    enable = true;
    # package = pkgs.umbriel;
    # portalPackage = pkgs.xdg-desktop-portal-umbriel;
  };

  programs.labwc.enable = true;

  # Noctalia shell and desktop environment integration
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    # package = pkgs.noctalia;
  };

  # Desktop Portals configuration
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];

    wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
      };
    };

    config = {
      umbriel = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "umbriel" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "umbriel" ];
      };

      labwc = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    };
  };

  # Set PCManFM as the default file manager
  xdg.mime.defaultApplications = {
    "inode/directory" = "pcmanfm-qt.desktop";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      # UI/UX
      ibm-plex
      customPackages.google-sans-flex

      # Primary Monospace / Coding Font
      maple-mono.NF-CN

      # Fallback & Icon Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      noto-fonts-color-emoji
      undefined-medium
      annotation-mono
      nerd-fonts.terminess-ttf
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "Annotation Mono"
          "Maple Mono NF CN"
          "JetBrainsMono Nerd Font"
        ];
        sansSerif = [
          "IBM Plex Sans"
        ];
        serif = [
          "IBM Plex Serif"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
