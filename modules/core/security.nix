{ ... }:

{
  security = {
    polkit.enable = true;

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

    sudo.enable = false;
  };
}
