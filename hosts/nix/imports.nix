{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/imports.nix
  ];

  system.stateVersion = "26.05";
}
