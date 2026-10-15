{
  nix.settings = {
    substituters = [
      "https://icyatnix.cachix.org"
      "https://noctalia.cachix.org"
      "https://umbriel.cachix.org"
    ];

    trusted-public-keys = [
      "icyatnix.cachix.org-1:lz0Zhp64TdX+uWXMugnTuyoEmyTwOQYAm7Zc3FFItOs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };
}
