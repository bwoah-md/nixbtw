{ pkgs, ... }:

{
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "icy" ];

    # package = pkgs.noctalia-greeter;
    greeter-args = "--session umbriel --user icy";

    settings = {
      cursor = {
        theme = "Adwaita";
        size = 24;
        path = "${pkgs.adwaita-icon-theme}/share/icons";
      };
    };
  };

  # Automatically unlock the GNOME Keyring using the login password
  security.pam.services.greetd.enableGnomeKeyring = true;
}
