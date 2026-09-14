{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/desktop/desktop.nix
    ../../modules/hardware/intel.nix
    ../../modules/services
    ../../modules/packages/packages.nix

    ../../users/icy/shell.nix
  ];

  system.stateVersion = "26.05";
}
