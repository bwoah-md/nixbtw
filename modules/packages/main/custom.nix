{ pkgs, lib }:
{
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

    meta.mainProgram = "superseedr";
  };

  strata = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "strata";
    version = "1.1.1";

    src = pkgs.fetchurl {
      url = "https://github.com/lgse/strata/releases/download/v${finalAttrs.version}/strata-${finalAttrs.version}-x86_64-unknown-linux-gnu.tar.gz";
      hash = "sha256-4FUuB3L83tE6gohHR7KPCzIiCjKTHNpuVfg1dbvlBzQ=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      makeWrapper
      wrapGAppsHook4
    ];

    buildInputs = with pkgs; [
      bubblewrap
      ffmpeg
      ffmpegthumbnailer
      fontconfig
      gdk-pixbuf
      webp-pixbuf-loader
      glib
      gtk4
      gtksourceview5
      poppler
      gvfs
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-libav
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 strata \
        $out/libexec/strata-unwrapped

      mkdir -p $out/bin

      makeWrapper $out/libexec/strata-unwrapped $out/bin/strata \
        --prefix PATH : ${lib.makeBinPath [
          pkgs.bubblewrap
          pkgs.ffmpeg
          pkgs.ffmpegthumbnailer
          pkgs.gvfs
        ]} \
        --set STRATA_SANDBOX_ROOT "/nix/store" \
        --set STRATA_SANDBOX_PATH "${lib.makeBinPath [
          pkgs.ffmpeg
          pkgs.ffmpegthumbnailer
        ]}" \
        --set STRATA_SANDBOX_PRLIMIT "${pkgs.util-linux}/bin/prlimit" \
        --set STRATA_SANDBOX_GDK_PIXBUF_MODULE_FILE \
          "${pkgs.webp-pixbuf-loader}/${pkgs.gdk-pixbuf.binaryDir}/webp-loaders.cache"

      install -Dm644 io.github.lgse.Strata.desktop \
        $out/share/applications/io.github.lgse.Strata.desktop

      sed -i \
        "s|^Exec=strata|Exec=$out/bin/strata|" \
        $out/share/applications/io.github.lgse.Strata.desktop

      install -Dm644 io.github.lgse.Strata.svg \
        $out/share/icons/hicolor/scalable/apps/io.github.lgse.Strata.svg

      install -Dm644 io.github.lgse.Strata.FileManager1.service \
        $out/share/strata/io.github.lgse.Strata.FileManager1.service

      runHook postInstall
    '';

    meta = {
      description = "Fast, keyboard-first Linux file manager";
      homepage = "https://github.com/lgse/strata";
      license = lib.licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = "strata";
    };
  });
}
