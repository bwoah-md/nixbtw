{ ... }:

{
  # Docker service configured for manual start
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };
}
