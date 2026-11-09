{ pkgs }:

pkgs.rustPlatform.buildRustPackage rec {
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
}
