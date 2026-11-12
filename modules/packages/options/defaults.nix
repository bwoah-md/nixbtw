{ ... }:

{
  # default --- File Explorer
  xdg.mime.defaultApplications = {
    "inode/directory" = "com.thisisgm.flea.desktop";
    # "inode/directory" = "io.github.lgse.Strata.desktop";
  };

  # default --- Fonts
  fonts.fontconfig.defaultFonts = {
    monospace = [ "Maple Mono NF CN" ];
    sansSerif = [ "Google Sans Flex" ];
    serif = [ "IBM Plex Serif" ];
    emoji = [ "Noto Color Emoji" ];
  };

  # default --- Web Browser
  environment.sessionVariables.BROWSER = "librewolf";

  # disable --- Nano
  programs.nano.enable = false;
}
