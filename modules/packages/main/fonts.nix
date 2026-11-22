{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      ibm-plex
      # maple-mono.NF-CN
      nerd-fonts.jetbrains-mono
      # nerd-fonts.iosevka
      noto-fonts-color-emoji
      undefined-medium
      # annotation-mono
      # nerd-fonts.terminess-ttf
      # nerd-fonts.go-mono
      nerd-fonts.fantasque-sans-mono
    ];

    fontconfig.allowBitmaps = true;
  };
}
