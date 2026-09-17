{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./fish.nix
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

    enableCompletion = true;
    enableLsColors = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    histSize = 10000;
    histFile = "$HOME/.zsh_history";

    setOptions = [
      "SHARE_HISTORY"
      "HIST_IGNORE_SPACE"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_SAVE_NO_DUPS"
      "HIST_FIND_NO_DUPS"
      "HIST_REDUCE_BLANKS"
    ];

    shellAliases = {
      # General
      btop = "btop --force-utf";
      sudo = "sudo ";
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
      export PATH="$HOME/.local/bin:$PATH"
      export EDITOR="${pkgs.helix}/bin/hx"
      export VISUAL="${pkgs.helix}/bin/hx"
      export FZF_BASE="${pkgs.fzf}/share/fzf"

      [[ -f ~/.config/fzf/themes/noctalia.sh ]] && \
        source ~/.config/fzf/themes/noctalia.sh
    '';

    interactiveShellInit = ''
      # Terminal title
      precmd() {
        print -Pn "\e]0;%~\a"
      }

      preexec() {
        print -Pn "\e]0;$1\a"
      }

      # Case-insensitive ZSH completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={a-zA-Z}'

      # Completion colors
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # bat
      help() {
        "$@" --help 2>&1 | bat --plain --language=help
      }

      # Dotfiles
      # Stage, review, and locally commit changes already copied into ~/.dotfiles.
      # Does NOT copy files from ~/.config or push to GitHub.
      dotfrost() {
        local repo="$HOME/.dotfiles"
        local message

        echo "==> Staging dotfiles..."
        git -C "$repo" add -A

        echo
        echo "==> Changes staged:"
        git -C "$repo" status --short

        echo
        echo "==> Staged diff:"
        git -C "$repo" diff --cached

        echo
        read "message?Commit message: "

        if [[ -z "$message" ]]; then
          echo "No commit message supplied. Aborting."
          git -C "$repo" reset
          return 1
        fi

        echo
        echo "==> Creating commit..."
        git -C "$repo" commit -m "$message"
      }

      # zoxide
      eval "$(zoxide init zsh)"

      # carapace
      export CARAPACE_BRIDGES='zsh'
      source <(carapace _carapace)

      # atuin
      eval "$(atuin init zsh)"

      # Alt+T → fzf directory search
      fzf-cd-widget() {
        local dir
        dir=$(find . -type d 2>/dev/null | fzf)

        if [[ -n "$dir" ]]; then
          BUFFER="cd ''${(q)dir}"
          zle accept-line
        fi
      }

      zle -N fzf-cd-widget

      # --------------------------
      # --- Custom Keybindings ---
      # --------------------------

      # Alt+Backspace → delete one path component
      WORDCHARS=''${WORDCHARS//\/}
      bindkey '^[^?' backward-kill-word

      # Ctrl+Left/Right → jump one word
      bindkey '\e[1;5D' backward-word
      bindkey '\e[1;5C' forward-word

      # Ctrl+Delete → delete next word
      bindkey '\e[3;5~' kill-word
    '';

    promptInit = ''
      # Starship
      eval "$(starship init zsh)"

      # fzf
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      # Ctrl+R → Atuin
      bindkey '^R' atuin-search

      # Alt+T → fzf directory search
      bindkey '^[t' fzf-cd-widget
    '';
  };
}
