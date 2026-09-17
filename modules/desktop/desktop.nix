{ inputs, pkgs, lib, ... }:
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

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Primary Monospace / Coding Font
      maple-mono.NF-CN
      # Fallback & Icon Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      font-awesome
      undefined-medium
      annotation-mono
      nerd-fonts.terminess-ttf
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Annotation Mono" "Maple Mono NF CN" "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
        serif = [ "Noto Serif" "Noto Serif CJK SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
