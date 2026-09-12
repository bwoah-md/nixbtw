{
  imports = [
    ./git.nix

    # Choose ONE:
    ./shell/fish.nix
    # ./shell/zsh.nix
  ];

  users.users.icy = {
    isNormalUser = true;
    description = "icy";

    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "docker"
      "kvm"
    ];
  };

  users.groups.icy = {};
}
