
{ config, pkgs, ... }:

{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 2;
    };
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Virtual camera kernel support for OBS.
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];

  boot.kernelModules = [ "v4l2loopback" ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1
  '';
}
