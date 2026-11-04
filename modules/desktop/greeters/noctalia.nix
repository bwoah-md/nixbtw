{ pkgs, ... }:

{
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordlessSyncUsers = [ "icy" ];
    package = pkgs.noctalia-greeter;

    extraArgs = [
      "--session"
      "umbriel"
      "--user"
      "icy"
    ];

    settings = {
      cursor = {
        theme = "capitaine-cursors";
        size = 24;
        path = "${pkgs.capitaine-cursors}/share/icons";
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
}
