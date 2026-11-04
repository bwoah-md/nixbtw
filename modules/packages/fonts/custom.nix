{ pkgs, lib }:
{
  google-sans-flex = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "google-sans-flex";
    version = "4.007";

    src = pkgs.fetchurl {
      url = "https://github.com/googlefonts/googlesans-flex/releases/download/v${finalAttrs.version}/GoogleSansFlex-v${finalAttrs.version}.zip";
      hash = "sha256-tzdRMb/8Xqrr62XGlSm6EOf3qZYrkTSI9u81xDLOGck=";
    };

    nativeBuildInputs = [ pkgs.unzip ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype/google-sans-flex

      unzip -q $src -d $TMPDIR/google-sans-flex

      find $TMPDIR/google-sans-flex \
        -type f \
        -iname '*.ttf' \
        -exec install -Dm644 {} \
          $out/share/fonts/truetype/google-sans-flex/$(basename {}) \;
    '';

    meta = {
      homepage = "https://github.com/googlefonts/googlesans-flex";
      description = "Google Sans Flex variable typeface";
      license = lib.licenses.ofl;
      platforms = lib.platforms.all;
    };
  });
}
