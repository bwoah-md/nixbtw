{ pkgs, ... }:

let
  localsend-wrapped = pkgs.symlinkJoin {
    name = "localsend";
    paths = [ pkgs.localsend ];
    nativeBuildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/localsend_app \
        --set GDK_BACKEND wayland \
        --set GTK_CSD 0 \
        --add-flags "--hidden-title-bar"
    '';
  };
in
{
  # OBS Studio
  # if you want to add the v4l2loopback kernel module, then it should live in modules/core/boot.nix
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-pipewire-audio-capture
    ];
  };

  # LocalSend
  programs.localsend = {
    enable = true;
    openFirewall = true;
    package = localsend-wrapped;
  };

  # Misc integrations
  programs.nix-ld.enable = true;
  programs.kdeconnect.enable = true;

  # Secret Service / OS keyring
  services.gnome.gnome-keyring.enable = true;

  # Helium browser
  programs.helium = {
    enable = true;
    flags = [
      "--ozone-platform-hint=auto"
      "--enable-features=TouchpadOverscrollHistoryNavigation"
    ];
  };
}
