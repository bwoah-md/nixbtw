{ ... }:

{
  environment.sessionVariables = {
    # Nix Packages
    NIXPKGS_ALLOW_UNFREE = "1";

    # QT
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # Wayland
    NIXOS_OZONE_WL = "1";
  };
}
