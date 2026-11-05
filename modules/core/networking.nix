{ ... }:

{
  networking = {
    hostName = "nix";

    networkmanager = {
      enable = true;
      # prevent NetworkManager DHCP from overriding static Cloudflare nameservers
      dns = "none";
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];

    firewall.enable = true;
  };
}
