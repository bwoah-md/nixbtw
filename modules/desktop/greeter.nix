{ pkgs, ... }:

{
  services.displayManager.noctalia-greeter = {
    enable = true;
    # package = pkgs.noctalia-greeter;
    greeter-args = "--session umbriel --user icy";
    settings = {
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
        path = "${pkgs.bibata-cursors}/share/icons";
      };
    };
  };
}
