{ pkgs, inputs, customPackages, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      qutebrowser = prev.qutebrowser.override {
        enableWideVine = true;
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    # ─────────────────────────────────────────────────
    # Custom Apps
    # ─────────────────────────────────────────────────
    inputs.sonora.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.cressida.packages.${pkgs.stdenv.hostPlatform.system}.default
    customPackages.rayburst

    # ─────────────────────────────────────────────────
    # Shell & Terminal
    # ─────────────────────────────────────────────────
    foot
    # kitty
    # ghostty

    # --- CLI ---
    btop
    surge-downloader
    fastfetch
    yazi
    ripgrep
    lazygit
    # tree
    # diskbloom               # ncdu replacement
    # cliamp

    # --- Terminal Toys ---
    cbonsai
    unimatrix
    cava
    dwt1-shell-color-scripts

    # ─────────────────────────────────────────────────
    # Editors
    # ─────────────────────────────────────────────────
    zed-editor
    helix
    tuios
    zellij
    # fresh-editor
    # neovim

    # ─────────────────────────────────────────────────
    # Browsers
    # ─────────────────────────────────────────────────
    mullvad-browser
    qutebrowser
    librewolf
    # tor-browser

    # ─────────────────────────────────────────────────
    # CLI / File Utilities
    # ─────────────────────────────────────────────────
    wget
    curl
    rsync
    bat
    eza
    zoxide
    atuin
    # rclone                # cloud storage

    # Archives
    _7zz
    unzip
    unrar
    p7zip
    zip
    rar

    # ─────────────────────────────────────────────────
    # Cursors, Themes and Icons
    # ─────────────────────────────────────────────────
    capitaine-cursors

    # ─────────────────────────────────────────────────
    # Wayland / Desktop Utilities
    # ─────────────────────────────────────────────────
    hyprpicker
    wl-clipboard
    gpu-screen-recorder
    ffmpegthumbnailer

    # ─────────────────────────────────────────────────
    # Media
    # ─────────────────────────────────────────────────
    mpv
    ffmpeg
    yt-dlp
    qview
    scrcpy

    # ─────────────────────────────────────────────────
    # Editing
    # ─────────────────────────────────────────────────
    krita
    krita-plugin-gmic
    kdePackages.kdenlive

    # ─────────────────────────────────────────────────
    # Communication
    # ─────────────────────────────────────────────────
    equibop
    telegram-desktop
    # zoom-us
    # signal-desktop

    # ─────────────────────────────────────────────────
    # Windows / Remote Desktop
    # ─────────────────────────────────────────────────
    freerdp
    dialog
    libnotify
    netcat-openbsd

    # ─────────────────────────────────────────────────
    # Applications
    # ─────────────────────────────────────────────────
    obsidian
    readest
    sioyek
    kdePackages.partitionmanager
    zapfast
    # (zathura.override {
    #   plugins = [
    #     zathuraPkgs.zathura_pdf_mupdf
    #   ];
    # })
    # nautilus
    # pcmanfm-qt
    # lxqt.lxqt-archiver

    # ─────────────────────────────────────────────────
    # Theming
    # ─────────────────────────────────────────────────
    adw-gtk3
    kdePackages.qt6ct
    libsForQt5.qt5ct
    klassy
    nwg-look
    # kdePackages.kcolorscheme
    # kdePackages.qtsvg
    # papirus-icon-theme
    # adwaita-icon-theme

    # ─────────────────────────────────────────────────
    # Development
    # ─────────────────────────────────────────────────
    fd
    gh
    # nix-update
    # nix-output-monitor
    # nil
    # nixd
    # nixfmt

    # (python3.withPackages (ps: [
    #   ps.pygobject3
    # ]))
    # bubblewrap
    # nodejs
    # jq
    # sshfs

    # ─────────────────────────────────────────────────
    # Neovim Tools
    # ─────────────────────────────────────────────────
    # gcc
    # fd
    # tree-sitter
    # imagemagick

    # ─────────────────────────────────────────────────
    # Hardware & System Diagnostics
    # ─────────────────────────────────────────────────
    # pciutils
    # usbutils
    # dmidecode
    # smartmontools
    # alsa-utils
  ];
}
