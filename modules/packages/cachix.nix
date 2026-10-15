{
  nix.settings = {
    substituters = [
      "https://icyatnix.cachix.org"
      "https://noctalia.cachix.org"
    ];

    trusted-public-keys = [
      "icyatnix.cachix.org-1:lz0Zhp64TdX+uWXMugnTuyoEmyTwOQYAm7Zc3FFItOs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
}
