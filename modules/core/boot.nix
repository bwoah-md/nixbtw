{ pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 2;
      };
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  security = {
    polkit.enable = true;

    # Doas
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "icy" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };

    # disable sudo
    sudo.enable = false;
  };
}
