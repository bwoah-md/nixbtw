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
    # Apps from Cachix
    # ─────────────────────────────────────────────────
    inputs.sonora.packages.${pkgs.stdenv.hostPlatform.system}.sonora-bin
    customPackages.misterdownloadmanager
    # inputs.cressida.packages.${pkgs.stdenv.hostPlatform.system}.default

    # ─────────────────────────────────────────────────
    # Custom Packages (from modules/packages/main/custom/)
    # ─────────────────────────────────────────────────
    customPackages.superseedr

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
    # Cursors
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
    # zapfast
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
    # kdePackages.kcolorscheme
    # klassy
    # kdePackages.qtsvg
    # nwg-look
    # papirus-icon-theme
    # adwaita-icon-theme

    # ─────────────────────────────────────────────────
    # Development
    # ─────────────────────────────────────────────────
    nix-update
    fd
    nix-output-monitor
    # nil
    # nixd
    # nixfmt
    # gh

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
