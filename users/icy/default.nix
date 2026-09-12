{ inputs, pkgs, ... }:
{
  imports = [
    ./git.nix
  ];

  users.users.icy = {
    isNormalUser = true;
    description = "icy";
    shell = pkgs.zsh;

    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "docker"
      "kvm"
    ];
  };

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  programs.starship.enable = true;

  programs.zsh = {
    enable = true;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    histSize = 10000;
    histFile = "$HOME/.zsh_history";

    setOptions = [
      "INC_APPEND_HISTORY"
      "SHARE_HISTORY"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_SAVE_NO_DUPS"
      "HIST_REDUCE_BLANKS"
    ];

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
      nixadd     = "git -C ~/.config/nixos add -A";
      nixcommit  = "git -C ~/.config/nixos commit -m";
      nixpush    = "git -C ~/.config/nixos push origin main";
      nixpull    = "git -C ~/.config/nixos pull origin main";
      nixstatus  = "git -C ~/.config/nixos status";

      nixrebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos#nix";

      nixupdate = "cd ~/.config/nixos && nix-update superseedr --flake --build && nix-update ghosttime --flake --build && rm -f result";

      nixclean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      nixflake = "nix flake update --flake ~/.config/nixos";

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
      docker-stop  = "sudo systemctl stop docker";

      # Windows VM
      win = "sdl-freerdp /u:\"icy\" /p:\"1771\" /v:127.0.0.1:3389 /cert:ignore /dynamic-resolution +clipboard /sound /microphone +home-drive";

      win-start = "sudo systemctl start docker && docker start windows";
      win-stop  = "docker stop windows && sudo systemctl stop docker";

      # Phone
      mount-phone  = "mkdir -p ~/LineageOS && sshfs LineageOS:/storage/emulated/0 ~/LineageOS";
      umount-phone = "fusermount -u ~/LineageOS";
    };

    shellInit = ''
      export PATH="$HOME/.local/bin:$PATH"
      export FZF_BASE="${pkgs.fzf}/share/fzf"

      [[ -f ~/.config/fzf/themes/noctalia.sh ]] && \
        source ~/.config/fzf/themes/noctalia.sh
    '';

    interactiveShellInit = ''
      # bat
      help() {
        "$@" --help 2>&1 | bat --plain --language=help
      }

      # zoxide
      eval "$(zoxide init zsh)"

      # carapace
      export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
      source <(carapace _carapace)

      # atuin
      eval "$(atuin init zsh)"

      # Helix mode
      source ${inputs.zsh-helix-mode}/share/zsh-helix-mode/zsh-helix-mode.plugin.zsh

      # zsh-autosuggestions compatibility
      ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
        zhm_history_prev
        zhm_history_next
        zhm_prompt_accept
        zhm_accept
        zhm_accept_or_insert_newline
      )

      ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(
        zhm_move_right
        zhm_clear_selection_move_right
      )

      ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
        zhm_move_next_word_start
        zhm_move_next_word_end
      )
    '';

    promptInit = ''
      # fzf
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      # Ctrl+R → Atuin history search
      bindkey '^R' atuin-search

      # Alt+T → fzf directory search
      bindkey '^[t' fzf-cd-widget
    '';
  };
}
