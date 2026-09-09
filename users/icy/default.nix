{ pkgs, ... }:
{
  imports = [
    ./git.nix
  ];

  users.users.icy = {
    isNormalUser = true;
    description = "icy";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "kvm" ];
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
      btop = "btop --force-utf";
      sudo = "sudo ";
      # v = "nvim";
      ff = "fastfetch";

      nixadd     = "git -C ~/.config/nixos add -A";
      nixcommit  = "git -C ~/.config/nixos commit -m";
      nixpush    = "git -C ~/.config/nixos push origin main";
      nixpull    = "git -C ~/.config/nixos pull origin main";
      nixstatus  = "git -C ~/.config/nixos status";
      nixrebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos#nix";
      nixupdate  = "cd ~/.config/nixos && nix-update swash --flake --build && nix-update superseedr --flake --build && nix-update ghosttime --flake --build";
      nixclean   = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      nixflake   = "nix flake update --flake ~/.config/nixos";

      docker-start = "sudo systemctl start docker";
      docker-stop  = "sudo systemctl stop docker";

      win = "sdl-freerdp /u:\"icy\" /p:\"1771\" /v:127.0.0.1:3389 /cert:ignore /dynamic-resolution +clipboard /sound /microphone +home-drive";

      win-start = "sudo systemctl start docker && docker start windows";
      win-stop  = "docker stop windows && sudo systemctl stop docker";

      mount-phone  = "mkdir -p ~/LineageOS && sshfs LineageOS:/storage/emulated/0 ~/LineageOS";
      umount-phone = "fusermount -u ~/LineageOS";
    };

    shellInit = ''
      export PATH="$HOME/.local/bin:$PATH"
      export FZF_BASE="${pkgs.fzf}/share/fzf"
      [[ -f ~/.config/fzf/themes/noctalia.sh ]] && source ~/.config/fzf/themes/noctalia.sh

      # Launch Zed completely detached, always opening a new window
      zed() {
        ${pkgs.zed-editor}/libexec/zed-editor -n "$@" >/dev/null 2>&1 &!
      }

      nixfrost() {
        nixupdate && \
        rm result && \
        nixflake && \
        nixadd && \
        nixrebuild && \
        nixcommit "ran nixfrost at $(date '+%-d %b, %Y at %H:%M')" && \
        nixpush && \
        nixclean
      }
    '';

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "copypath" ];
    };

    promptInit = ''
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
    '';
  };
}
