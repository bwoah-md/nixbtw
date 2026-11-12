{ pkgs, ... }:
{
  users.users.icy = {
    isNormalUser = true;
    description = "icy";
    shell = pkgs.bash;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "kvm" ];
  };

  # NixOS Helper
  programs.nh = {
    enable = true;
    flake = "/home/icy/.config/nixos";
  };

  # Television
  programs.television = {
    enable = true;
    enableFishIntegration = true;
  };

  # Zoxide
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Atuin
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = false;
      search_mode = "fuzzy";
      style = "compact";
    };
  };

  # Starship
  programs.starship.enable = true;

  # Fish
  programs.fish = {
    enable = true;

    shellAbbrs = {
      # General
      btop = "btop --force-utf";
      mf = "clear && fastfetch -c micro";
      sf = "clear && fastfetch -c small";
      tf = "clear && fastfetch -c tiny";
      c = "clear";

      # bat / eza
      cat = "bat --paging=never";
      bathelp = "bat --plain --language=help";
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
      nixrebuild = "nh os switch -H nix";
      nixupdate = "cd ~/.config/nixos && nix-update superseedr --flake --build && rm -f result";
      nixclean = "doas nix-collect-garbage -d && nix-collect-garbage -d";
      nixflake = "nix flake update nixpkgs noctalia helium-flake winapps umbriel sonora --flake ~/.config/nixos";
      nixcachix = "nix flake update strata cressida flea --flake ~/.config/nixos && nix flake lock --update-input rayburst-nixpkgs --flake ~/.config/nixos";

      # Dotfiles
      dot = "cd ~/.dotfiles";
      dotstatus = "git -C ~/.dotfiles status";
      dotdiff = "git -C ~/.dotfiles diff";
      dotadd = "git -C ~/.dotfiles add -A";
      dotpush = "git -C ~/.dotfiles push";
      dotlog = "git -C ~/.dotfiles log --oneline --decorate --graph";
      dotremote = "git -C ~/.dotfiles remote -v";
      dotrestore = "cp -r ~/.dotfiles/* ~/.config/*";

      # Docker
      docker-start = "doas systemctl start docker";
      docker-stop = "doas systemctl stop docker";

      # Windows VM
      win = "sdl-freerdp /u:\"icy\" /p:\"1771\" /v:127.0.0.1:3389 /cert:ignore /dynamic-resolution +clipboard /sound /microphone +home-drive";
      win-start = "doas systemctl start docker && docker start windows";
      win-stop = "docker stop windows && doas systemctl stop docker";

      # Phone
      mount-phone = "mkdir -p ~/LineageOS && sshfs LineageOS:/storage/emulated/0 ~/LineageOS";
      umount-phone = "fusermount -u ~/LineageOS";
    };

    shellInit = ''
      set -gx PATH $HOME/.local/bin $PATH
      set -gx EDITOR ${pkgs.helix}/bin/hx
      set -gx VISUAL ${pkgs.helix}/bin/hx
      set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
      set -gx MANROFFOPT "-c"
    '';

    interactiveShellInit = ''
      set fish_greeting

      function fish_title
        set -l cmd (status current-command)
        if test -z "$cmd"; or test "$cmd" = fish
          echo fish
        else
          echo $cmd
        end
      end

      function tv-cd
        set -l dir (tv dirs)
        if test -n "$dir"
          cd -- "$dir"
        end
        commandline -f repaint
      end
      bind \et tv-cd

      function help
        $argv --help 2>&1 | bat --plain --language=help
      end

      function dotcommit
        set -l repo "$HOME/.dotfiles"
        git -C "$repo" add -A; or return 1
        git -C "$repo" status --short
        git -C "$repo" diff --cached
        read -l -P "Commit message: " message
        if test -z "$message"
          git -C "$repo" reset
          return 1
        end
        git -C "$repo" commit -m "$message"
      end
    '';

    promptInit = ''
      starship init fish | source
    '';
  };
}
