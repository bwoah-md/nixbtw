
{
  lib,
  rustPlatform,
  buildFHSEnv,
  runCommand,
  runtimeShell,
  writeShellScript,
  writeShellScriptBin,
  pkg-config,
  bubblewrap,
  glibc,
  python3,
  gobject-introspection,
  glib,
  expect,
  bat,
  util-linux,
  gvfs,
  jq,
  quickjs-ng,
  ripgrep,
  shared-mime-info,
  udisks,
  usbmuxd,
  wl-clipboard,
  xdg-terminal-exec,
  xdg-utils,
  poppler,
  poppler-utils,
  mpv-unwrapped,
  vulkan-loader,
  libGL,
  wayland,
  diffutils,
  git,
  quickshell,
  fontconfig,
  freetype,
  gdk-pixbuf,
  libheif,
  libxcb,
  libxkbcommon,
  hicolor-icon-theme,
  qt6,
  _7zz,
  libarchive,
  ffmpeg,
  ffmpegthumbnailer,
  imagemagick,
  # libreoffice,
  # tailscale,
  zoxide,
  fleaSrc,
  withHtmlPreview ? true,
  extraPackages ? [ ],
  omarchyPath ? "/run/current-system/sw/share/omarchy",
}:

let
  version =
    (builtins.fromTOML (builtins.readFile "${fleaSrc}/Cargo.toml"))
      .package.version;

  flea-unwrapped = rustPlatform.buildRustPackage {
    pname = "flea";
    inherit version;
    src = fleaSrc;

    cargoHash = "sha256-z64BjWipyFhkrgtown7VTg3G1pcs5NV4adCPXLMrR0Q=";

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      glib
      fontconfig
      freetype
      gdk-pixbuf
      libheif
      libxcb
      libxkbcommon
      wayland
      libGL
      vulkan-loader
      mpv-unwrapped
      poppler
    ];

    cargoBuildFlags = [
      "--frozen"
      "--workspace"
      "--bins"
    ];

    doCheck = false;
    dontCheckForBrokenSymlinks = true;
    dontPatchShebangs = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"

      # Main executables
      install -Dm755 target/release/flea "$out/bin/flea"
      install -Dm755 target/release/flea-gui "$out/bin/flea-gui"

      # Runtime helper programs
      install -Dm755 tools/flea-gio-auth "$out/lib/flea/flea-gio-auth"
      install -Dm755 tools/flea-udisks "$out/lib/flea/flea-udisks"
      install -Dm755 tools/flea-portal "$out/lib/flea/flea-portal"
      install -Dm755 tools/flea-filemanager1 "$out/lib/flea/flea-filemanager1"
      install -Dm755 tools/flea-mpris "$out/lib/flea/flea-mpris"

      # Portal and D-Bus integration
      install -Dm644 packaging/flea.portal \
        "$out/share/xdg-desktop-portal/portals/flea.portal"

      install -Dm644 packaging/org.freedesktop.impl.portal.desktop.flea.service \
        "$out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.flea.service"

      install -Dm644 packaging/com.thisisgm.flea.FileManager1.service \
        "$out/share/dbus-1/services/com.thisisgm.flea.FileManager1.service"

      # Desktop entry and icon
      install -Dm644 packaging/com.thisisgm.flea.desktop \
        "$out/share/applications/com.thisisgm.flea.desktop"

      install -Dm644 packaging/com.thisisgm.flea.svg \
        "$out/share/icons/hicolor/scalable/apps/com.thisisgm.flea.svg"

      # Licenses
      install -Dm644 LICENSE "$out/share/licenses/flea/LICENSE"
      install -Dm644 THIRD-PARTY-LICENSES.txt \
        "$out/share/licenses/flea/THIRD-PARTY-LICENSES.txt"

      # QML interface
      install -Dm644 ui/qmldir ui/*.qml ui/*.js \
        -t "$out/share/flea/ui"

      install -Dm644 ui/js/*.js ui/js/*.mjs \
        -t "$out/share/flea/ui/js"

      install -Dm644 ui/vendor/*.mjs \
        -t "$out/share/flea/ui/vendor"

      install -Dm644 ui/vendor/LICENSES/* \
        -t "$out/share/flea/ui/vendor/LICENSES"

      install -Dm644 \
        ui/boot/shell.qml \
        ui/boot/picker.qml \
        ui/boot/fleatab.qml \
        ui/boot/tabtearoff.qml \
        -t "$out/share/flea/ui/boot"

      # Shelf plugin
      install -Dm644 \
        shelf/manifest.json \
        shelf/README.md \
        shelf/*.qml \
        shelf/*.js \
        -t "$out/share/flea/shelf"

      # Translation catalogs
      for catalog in i18n/*/flea.json; do
        install -Dm644 "$catalog" "$out/share/flea/$catalog"
      done

      # Keep the packaged shelf version aligned with the Nix package version.
      sed -i \
        "s/^  \\"version\\": \\"[^\\"]*\\",\$/  \\"version\\": \\"${version}-1\\",/" \
        "$out/share/flea/shelf/manifest.json"

      grep -qF '  "version": "${version}-1",' \
        "$out/share/flea/shelf/manifest.json" || {
          echo "flea: shelf manifest version update failed" >&2
          exit 1
        }

      # Omarchy compatibility paths expected by Flea's QML imports.
      ln -s /usr/share/omarchy/shell/Commons \
        "$out/share/flea/ui/Commons"

      ln -s /usr/share/omarchy/shell/Ui \
        "$out/share/flea/ui/Ui"

      ln -s /usr/share/omarchy/shell/Commons \
        "$out/share/flea/ui/boot/Commons"

      ln -s /usr/share/omarchy/shell/Ui \
        "$out/share/flea/ui/boot/Ui"

      runHook postInstall
    '';

    meta = {
      description = "Fast, keyboard-first file manager";
      homepage = "https://github.com/thisisgm/flea";
      license = with lib.licenses; [
        asl20
        bsd2
        bsd3
        cc0
        isc
        mit
        mpl20
        unicode3
        zlib
      ];
      mainProgram = "flea";
      platforms = [ "x86_64-linux" ];
    };
  };

  omarchyLink = runCommand "flea-omarchy-link" { } ''
    mkdir -p "$out/share"
    ln -s ${lib.escapeShellArg omarchyPath} "$out/share/omarchy"
  '';

  bwrapShim = writeShellScriptBin "bwrap" ''
    # Flea's Bubblewrap jails expect the host-style /etc layout.
    exec ${bubblewrap}/bin/bwrap \
      --ro-bind /nix/store /nix/store \
      --ro-bind ${glibc}/etc ${glibc}/etc \
      --ro-bind-try /.host-etc /.host-etc \
      "$@"
  '';

  # Flea invokes Arch's qml6 executable inside its HTML-preview jail.
  qml6Shim = writeShellScriptBin "qml6" ''
    export QML_IMPORT_PATH=/usr/lib/qt-6/qml
    export NIXPKGS_QT6_QML_IMPORT_PATH=/usr/lib/qt-6/qml
    exec /usr/bin/qml "$@"
  '';

  sevenzip7z = runCommand "flea-7z-link" { } ''
    mkdir -p "$out/bin"
    ln -s ${_7zz}/bin/7zz "$out/bin/7z"
  '';

  optionalPackages = {
    sevenzip = sevenzip7z;

    inherit
      libarchive
      ffmpeg
      ffmpegthumbnailer
      imagemagick
      # libreoffice
      # tailscale
      zoxide
      ;
  };

  flea-fhs = buildFHSEnv {
    name = "flea-fhs";

    runScript = writeShellScript "flea-fhs-exec" ''
      exec "$@"
    '';

    dieWithParent = false;

    profile = ''
      export GI_TYPELIB_PATH=/usr/lib/girepository-1.0
      export GIO_EXTRA_MODULES=/usr/lib/gio/modules

      chmod -R u+w \
        "''${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins/io.github.thisisgm.flea-shelf" \
        2>/dev/null || true
    '';

    extraBuildCommands = ''
      test -d "$out/usr/bin" -a ! -L "$out/usr/bin" || {
        echo "flea-fhs: usr/bin is not a real directory" >&2
        exit 1
      }

      tools="bat soffice libreoffice"

      for f in "$out"/usr/share/thumbnailers/*.thumbnailer; do
        [ -e "$f" ] || continue
        tools="$tools $(sed -n 's/^\(Try\)\?Exec=\([^ ]*\).*/\2/p' "$f" | xargs -r -n1 basename)"
      done

      for t in $(printf '%s\n' $tools | sort -u); do
        p="$out/usr/bin/$t"
        [ -L "$p" ] || continue

        real=$(readlink -f "$p")
        rm "$p"
        cp "$real" "$p"
      done

      # Flea rejects thumbnailer commands that point directly into /nix/store.
      for f in "$out"/usr/share/thumbnailers/*.thumbnailer; do
        [ -L "$f" ] || continue

        real=$(readlink -f "$f")
        rm "$f"

        sed -E \
          's#^((Try)?Exec=)/nix/store/[^/]+/bin/#\1/usr/bin/#' \
          "$real" > "$f"
      done
    '';

    targetPkgs = p: [
      flea-unwrapped
      bwrapShim
      omarchyLink

      (python3.withPackages (ps: [
        ps.pygobject3
      ]))

      gobject-introspection
      glib
      expect
      bat
      util-linux
      gvfs
      jq
      quickjs-ng
      ripgrep
      shared-mime-info
      udisks
      usbmuxd
      wl-clipboard
      xdg-terminal-exec
      xdg-utils
      poppler
      poppler-utils
      mpv-unwrapped
      vulkan-loader
      libGL
      wayland
      diffutils
      git
      quickshell
      fontconfig
      freetype
      gdk-pixbuf
      libheif
      libxcb
      libxkbcommon
      hicolor-icon-theme
      p.stdenv.cc.cc.lib
    ]
    ++ lib.optionals withHtmlPreview [
      qt6.qtdeclarative
      qt6.qtwebengine
      qml6Shim
    ]
    ++ extraPackages;
  };

in
runCommand "flea-${version}" {
  inherit version;

  passthru = {
    unwrapped = flea-unwrapped;
    fhs = flea-fhs;
    inherit optionalPackages;
  };

  meta = flea-unwrapped.meta // {
    description = "Flea file manager with an FHS runtime for NixOS";
  };
} ''
  mkdir -p \
    "$out/bin" \
    "$out/share/xdg-desktop-portal/portals" \
    "$out/share/dbus-1/services"

  cat > "$out/bin/flea" <<'EOF'
  #!${runtimeShell}
  exec ${flea-fhs}/bin/flea-fhs /usr/bin/flea "$@"
  EOF

  cat > "$out/bin/flea-gui" <<'EOF'
  #!${runtimeShell}
  exec ${flea-fhs}/bin/flea-fhs /usr/bin/flea-gui "$@"
  EOF

  chmod +x "$out/bin/flea" "$out/bin/flea-gui"

  ln -s ${flea-unwrapped}/share/applications "$out/share/applications"
  ln -s ${flea-unwrapped}/share/icons "$out/share/icons"
  ln -s ${flea-unwrapped}/share/licenses "$out/share/licenses"

  cp \
    ${flea-unwrapped}/share/xdg-desktop-portal/portals/flea.portal \
    "$out/share/xdg-desktop-portal/portals/"

  for service in ${flea-unwrapped}/share/dbus-1/services/*.service; do
    sed \
      's|^Exec=/usr/lib/flea/|Exec=${flea-fhs}/bin/flea-fhs /usr/lib/flea/|' \
      "$service" \
      > "$out/share/dbus-1/services/''${service##*/}"
  done
''
