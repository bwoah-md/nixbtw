{ lib, ... }:

{
  programs.dconf.enable = lib.mkDefault true;
  services.gvfs.enable = lib.mkDefault true;
  services.udisks2.enable = true;
}
