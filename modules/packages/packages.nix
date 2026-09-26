{ pkgs, inputs, lib, ... }:

let
  customPackages = import ./custom.nix {
    inherit pkgs lib;
  };
in
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      qutebrowser = prev.qutebrowser.override {
        enableWideVine = true;
      };
    })
  ];

  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    BROWSER = "firefox-beta";
  };

  # Disable NixOS's default Nano package
   programs.nano.enable = false;

  environment.systemPackages = with pkgs; [
    # ─────────────────────────────────────────────────
    # Custom Packages
    # ─────────────────────────────────────────────────
    customPackages.superseedr
    customPackages.ghosttime

    # ─────────────────────────────────────────────────
    # Shell & Terminal
    # ─────────────────────────────────────────────────
    zellij
    kitty
    foot
    # ghostty

    # CLI
    btop
    fastfetch
    yazi
    ripgrep
    tree
    diskbloom               # ncdu replacement
    concord-tui
    cliamp
    lazygit

    # Terminal Toys
    cbonsai
    unimatrix
    cava

    # ─────────────────────────────────────────────────
    # Editors
    # ─────────────────────────────────────────────────
    zed-editor
    helix
    fresh-editor
    # neovim

    # ─────────────────────────────────────────────────
    # Development
    # ─────────────────────────────────────────────────
    nixd
    nil
    nixfmt
    nix-update
    nodejs
    python3
    jq
    sshfs

    # ─────────────────────────────────────────────────
    # Neovim Tools
    # ─────────────────────────────────────────────────
    # gcc
    # fd
    # lazygit
    # tree-sitter
    # imagemagick

    # ─────────────────────────────────────────────────
    # Browsers
    # ─────────────────────────────────────────────────
    tor-browser
    mullvad-browser
    qutebrowser
    firefox-beta

    # ─────────────────────────────────────────────────
    # CLI / File Utilities
    # ─────────────────────────────────────────────────
    wget
    curl
    rsync
    rclone                # cloud storage

    bat                   # replacement to cat
    carapace              # multi-shell completion library
    eza
    zoxide
    atuin

    # Archives
    _7zz
    unzip
    unrar
    p7zip
    zip
    rar

    # ─────────────────────────────────────────────────
    # Hardware & System Diagnostics
    # ─────────────────────────────────────────────────
    # pciutils
    # usbutils
    # dmidecode
    # smartmontools
    # alsa-utils

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
    mpv                          # video player
    ffmpeg
    yt-dlp
    obs-studio                  # screen recorder
    qview                       # image viewer
    scrcpy                      # android screen

    # ─────────────────────────────────────────────────
    # Communication
    # ─────────────────────────────────────────────────
    equibop
    signal-desktop
    telegram-desktop

    # ─────────────────────────────────────────────────
    # Windows / Remote Desktop
    # ─────────────────────────────────────────────────
    freerdp
    dialog
    libnotify
    netcat-openbsd

    # ─────────────────────────────────────────────────
    # labwc
    # ─────────────────────────────────────────────────
    wlr-randr
    wlopm

    # ─────────────────────────────────────────────────
    # Applications
    # ─────────────────────────────────────────────────
    obsidian
    readest
    sioyek
    # nautilus
    klassy
    pcmanfm-qt
    inputs.zapfast.packages.${pkgs.system}.default
    lxqt.lxqt-archiver
  ];
}
