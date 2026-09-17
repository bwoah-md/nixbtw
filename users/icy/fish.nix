{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      # General
      btop = "btop --force-utf";
      ff = "fastfetch";
      c = "clear";

      # bat
      cat = "bat --paging=never";
      bathelp = "bat --plain --language=help";

      # eza
      ls = "eza";
      ll = "eza -lah";
      la = "eza -a";
      lt = "eza --tree";

      # Dotfiles (currently managed by .zshrc)
      # dot = "cd ~/.dotfiles";
      # dotstatus = "git -C ~/.dotfiles status";
      # dotdiff = "git -C ~/.dotfiles diff";
      # dotadd = "git -C ~/.dotfiles add -A";
      # dotpush = "git -C ~/.dotfiles push";
      # dotlog = "git -C ~/.dotfiles log --oneline --decorate --graph";
      # dotremote = "git -C ~/.dotfiles remote -v";
      # dotrestore = "cp -r ~/.dotfiles/* ~/.config/ && cp ~/.dotfiles/.zshrc ~/.zshrc";

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

    shellInit = ''
      set -gx PATH $HOME/.local/bin $PATH
      set -gx EDITOR ${pkgs.helix}/bin/hx
      set -gx VISUAL ${pkgs.helix}/bin/hx
      set -gx FZF_BASE ${pkgs.fzf}/share/fzf
    '';

    interactiveShellInit = ''
      # Disable Fish greeting
      set -g fish_greeting

      # bat
      function help
          $argv --help 2>&1 | bat --plain --language=help
      end

      # NixOS
      function nixadd
          git -C ~/.config/nixos add -A
      end

      function nixcommit
          git -C ~/.config/nixos commit -m $argv
      end

      function nixpush
          git -C ~/.config/nixos push origin main
      end

      function nixpull
          git -C ~/.config/nixos pull origin main
      end

      function nixstatus
          git -C ~/.config/nixos status
      end

      function nixrebuild
          sudo nixos-rebuild switch --flake ~/.config/nixos#nix
      end

      function nixupdate
          cd ~/.config/nixos
          nix-update superseedr --flake --build
          nix-update ghosttime --flake --build
          rm -f result
      end

      function nixclean
          sudo nix-collect-garbage -d
          nix-collect-garbage -d
      end

      function nixflake
          nix flake update --flake ~/.config/nixos
      end

      function nixfrost
          nixupdate &&
          nixflake &&
          nixadd &&
          nixrebuild &&
          nixcommit "ran nixfrost at $(date '+%-d %b, %Y at %H:%M')" &&
          nixpush &&
          nixclean
      end

      # Prompt
      function fish_prompt
          set -l last_status $status

          set -l cyan (set_color -o cyan)
          set -l red (set_color -o red)
          set -l green (set_color -o green)
          set -l normal (set_color --reset)

          set -l arrow_color $green

          if test $last_status != 0
              set arrow_color $red
          end

          set -l arrow "$arrow_color➜ "

          if fish_is_root_user
              set arrow "$arrow_color# "
          end

          set -l cwd $cyan(prompt_pwd)

          echo -n -s $arrow $cwd $normal ' '
      end
    '';
  };

  # Atuin: zsh only
  programs.atuin = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = true;
  };

  # Zoxide: fish only
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = false;
  };
}
