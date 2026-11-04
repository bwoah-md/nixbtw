{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    config = {
      safe.directory = [ "/etc/nixos" ];

      user = {
        name = "bwoah-md";
        email = "143240188+bwoah-md@users.noreply.github.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;

      core.editor = "${pkgs.helix}/bin/hx";
      credential.helper = "store";
    };
  };
}
