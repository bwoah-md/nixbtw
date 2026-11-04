{ pkgs, lib, ... }:

let
  customPackages = import ./custom.nix {
    inherit pkgs lib;
  };
in
{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      ibm-plex
      customPackages.google-sans-flex
      maple-mono.NF-CN
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      noto-fonts-color-emoji
      undefined-medium
      annotation-mono
      nerd-fonts.terminess-ttf
      nerd-fonts.go-mono
    ];
  };
}
