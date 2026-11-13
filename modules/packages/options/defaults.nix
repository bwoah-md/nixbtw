{ ... }:

{
  # default --- File Explorer
  xdg.mime.defaultApplications = {
    "inode/directory" = "nordend.desktop";
    # "inode/directory" = "io.github.lgse.Strata.desktop";
  };

  # default --- Fonts
  fonts.fontconfig.defaultFonts = {
    monospace = [ "Maple Mono NF CN" ];
    sansSerif = [ "IBM Plex Sans" ];
    serif = [ "IBM Plex Serif" ];
    emoji = [ "Noto Color Emoji" ];
  };

  # default --- Web Browser
  environment.sessionVariables.BROWSER = "librewolf";

  # disable --- Nano
  programs.nano.enable = false;
}
