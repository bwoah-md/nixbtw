{ pkgs, lib }:

{
  package = pkgs.rustPlatform.buildRustPackage rec {
    pname = "misterdownloadmanager";
    version = "0.5.2";

    src = pkgs.fetchFromGitHub {
      owner = "anefzaoui";
      repo = "misterdownloadmanager";
      rev = "v${version}";
      hash = "sha256-WRBG1npj6+//0YjWooMmw03ngVRkDx1WyhvwOL2+7sc=";
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

      install -d $out/share/applications

      cat > $out/share/applications/misterdownloadmanager.desktop <<EOF
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

    postFixup = ''
      wrapProgram $out/bin/misterdownloadmanager \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
          pkgs.libxkbcommon
          pkgs.wayland
          pkgs.gtk3
          pkgs.libGL
          pkgs.vulkan-loader
          pkgs.libX11
          pkgs.libXcursor
          pkgs.libXrandr
          pkgs.libXi
          pkgs.libxcb
        ]}
    '';

    meta = {
      description = "Free and open-source download manager";
      homepage = "https://github.com/anefzaoui/misterdownloadmanager";
      license = lib.licenses.gpl3Plus;
      platforms = [ "x86_64-linux" ];
      mainProgram = "misterdownloadmanager";
    };
  };

  # MDM Binary Cache
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
