{ pkgs, ... }:
{
  users.users.icy.shell = pkgs.fish;

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  programs.starship.enable = true;

  programs.fish = {
    enable = true;

    shellAliases = {
      # General
      btop = "btop --force-utf";
      sudo = "sudo ";
      ff = "fastfetch";

      # bat
      cat = "bat --paging=never";
      bathelp = "bat --plain --language=help";

      # eza
      ls = "eza";
      ll = "eza -lah";
      la = "eza -a";
      lt = "eza --tree";

      # NixOS
      nixadd = "git -C ~/.config/nixos add -A";
      nixcommit = "git -C ~/.config/nixos commit -m";
      nixpush = "git -C ~/.config/nixos push origin main";
      nixpull = "git -C ~/.config/nixos pull origin main";
      nixstatus = "git -C ~/.config/nixos status";

      nixrebuild =
        "sudo nixos-rebuild switch --flake ~/.config/nixos#nix";

      nixupdate =
        "cd ~/.config/nixos && nix-update superseedr --flake --build && nix-update ghosttime --flake --build && rm -f result";

      nixclean =
        "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      nixflake =
        "nix flake update --flake ~/.config/nixos";

      nixfrost = ''
        nixupdate &&
        nixflake &&
        nixadd &&
        nixrebuild &&
        nixcommit "ran nixfrost at $(date '+%-d %b, %Y at %H:%M')" &&
        nixpush &&
        nixclean
      '';

      # Docker
      docker-start = "sudo systemctl start docker";
      docker-stop = "sudo systemctl stop docker";

      # Windows VM
      win =
        "sdl-freerdp /u:\"icy\" /p:\"1771\" /v:127.0.0.1:3389 /cert:ignore /dynamic-resolution +clipboard /sound /microphone +home-drive";

      win-start =
        "sudo systemctl start docker && docker start windows";

      win-stop =
        "docker stop windows && sudo systemctl stop docker";

      # Phone
      mount-phone =
        "mkdir -p ~/LineageOS && sshfs LineageOS:/storage/emulated/0 ~/LineageOS";

      umount-phone =
        "fusermount -u ~/LineageOS";
    };

    shellFunctions = {
      # bat
      help = {
        body = ''
          "$argv[1]" --help 2>&1 | bat --plain --language=help
        '';
      };

      # fzf directory search
      fzf-cd-widget = {
        body = ''
          set -l dir (find . -type d 2>/dev/null | fzf)

          if test -n "$dir"
            cd "$dir"
          end
        '';
      };
    };

    interactiveShellInit = ''
      # PATH
      fish_add_path $HOME/.local/bin

      # fzf
      set -gx FZF_BASE ${pkgs.fzf}/share/fzf

      if test -f ~/.config/fzf/themes/noctalia.sh
        source ~/.config/fzf/themes/noctalia.sh
      end

      # zoxide
      zoxide init fish | source

      # Keybindings
      # Ctrl+T → fzf file search
      bind \ct fzf-file-widget

      # Alt+T → fzf directory search
      bind \et fzf-cd-widget
    '';
  };
}
