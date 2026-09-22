{ pkgs, lib }:
{
  superseedr = pkgs.rustPlatform.buildRustPackage {
    pname = "superseedr";
    version = "1.0.15";

    src = pkgs.fetchFromGitHub {
      owner = "Jagalite";
      repo = "superseedr";
      rev = "f484b50d144fb077e4f6e5ee3d2ce59273a8cf1a";
      hash = "sha256-RCPz4ugU7V5B6jl0wUg/mPxvoUX/TF0RM18tT0caTIM=";
    };

    cargoHash = "sha256-F6omghG3PWC9nQ/FNcDNm3r9+mpENx/npqiqD9tvi8Q=";

    doCheck = false;

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];

    meta.mainProgram = "superseedr";
  };

  ghosttime = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "ghosttime";
    version = "1.3.0";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/ghosttime/-/ghosttime-${finalAttrs.version}.tgz";
      hash = "sha256-QKR1OO+ZlCZm3tHXpGse2R0hH7G2xKwDm2H7/6tT5lU=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/node_modules/ghosttime $out/bin
      cp -r . $out/lib/node_modules/ghosttime
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/ghosttime \
        --add-flags "$out/lib/node_modules/ghosttime/dist/cli.js"
      runHook postInstall
    '';

    meta.mainProgram = "ghosttime";
  });

  google-sans-flex = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "google-sans-flex";
    version = "4.007";

    src = pkgs.fetchurl {
      url = "https://github.com/googlefonts/googlesans-flex/releases/download/v${finalAttrs.version}/GoogleSansFlex-v${finalAttrs.version}.zip";
      hash = "sha256-tzdRMb/8Xqrr62XGlSm6EOf3qZYrkTSI9u81xDLOGck=";
    };

    nativeBuildInputs = [
      pkgs.unzip
    ];

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
