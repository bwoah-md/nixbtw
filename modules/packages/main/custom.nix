{ pkgs, lib }:
{
  # ─────────────────────────────────────────────────
  # superseedr
  # ─────────────────────────────────────────────────
  superseedr = pkgs.rustPlatform.buildRustPackage rec {
    pname = "superseedr";
    version = "1.0.17";

    src = pkgs.fetchFromGitHub {
      owner = "Jagalite";
      repo = "superseedr";
      rev = "v${version}";
      hash = "sha256-NsEQmUFdI0Bl9kQX4Z2rF/tzkzMY/tI/5CPAIXDEJSg=";
    };

    cargoHash = "sha256-d7j5+QyYgKK+9y9roTRTkIm1QSjvI3YXSXWvfC2OP2s=";

    doCheck = false;

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];

    preBuild = ''
      unset AWS_LC_SYS_USE_SYSTEM
    '';

    meta.mainProgram = "superseedr";
  };

  # ─────────────────────────────────────────────────
  # Mister Download Manager
  # ─────────────────────────────────────────────────
  misterdownloadmanager = pkgs.rustPlatform.buildRustPackage rec {
    pname = "misterdownloadmanager";
    version = "0.5.1";

    src = pkgs.fetchFromGitHub {
      owner = "anefzaoui";
      repo = "misterdownloadmanager";
      rev = "v${version}";
      hash = "sha256-dLRGv1mq0pMZDkuYoRYHqAD0y+zmRyxau+3r+HlMY8M=";
    };

    cargoHash = "sha256-oyW4LWSzENHNIbQgZVH3BGVDeCZlZlLX5Noe33I5K6k=";
    cargoBuildFlags = [
      "--workspace"
      "--bins"
    ];

    doCheck = false;

    preBuild = ''
      unset AWS_LC_SYS_USE_SYSTEM
    '';

    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.makeWrapper
    ];

    buildInputs = with pkgs; [
      gtk3
      libxkbcommon
      wayland
      libGL
      vulkan-loader
      libX11
      libXcursor
      libXrandr
      libXi
      libxcb
    ];

    postInstall = ''
      install -Dm644 \
        crates/app/assets/icons/app/mdm-256.png \
        $out/share/icons/hicolor/256x256/apps/misterdownloadmanager.png

      install -Dm644 /dev/stdin \
        $out/share/applications/misterdownloadmanager.desktop <<EOF

    [Desktop Entry]
    Name=Mister Download Manager
    Comment=Download manager
    Exec=misterdownloadmanager
    Icon=misterdownloadmanager
    Terminal=false
    Type=Application
    Categories=Network;FileTransfer;
    EOF
    '';

    meta = {
      description = "Free and open-source download manager";
      homepage = "https://github.com/anefzaoui/misterdownloadmanager";
      license = lib.licenses.gpl3Plus;
      platforms = [ "x86_64-linux" ];
      mainProgram = "misterdownloadmanager";
    };
  };

  # ────── Binary Cache ──────
  nixosModule = {
    nix.settings = {
      extra-substituters = [
        "https://misterdownloadmanager.cachix.org"
      ];
      extra-trusted-public-keys = [
        "misterdownloadmanager.cachix.org-1:CZkwhLDHdo/WBrr4OrYsYXPwVxC1VYDFQQA75h+Axv8="
      ];
    };
  };
}
