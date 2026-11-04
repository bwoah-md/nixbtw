{ ... }:

{
  imports = [
    # ─────────────────────────────────────────────────
    # Core
    # ─────────────────────────────────────────────────
    ./core/boot.nix
    ./core/global.nix
    ./core/locale.nix
    ./core/networking.nix
    ./core/security.nix

    # ─────────────────────────────────────────────────
    # Desktop
    # ─────────────────────────────────────────────────

    # ────── Compositors ──────
    ./desktop/compositors/umbriel.nix
    ./desktop/compositors/labwc.nix

    # ────── Environment ──────
    ./desktop/environment/integration.nix
    ./desktop/environment/variables.nix

    # ────── Git ──────
    ./desktop/git/git.nix

    # ────── Greeters ──────
    ./desktop/greeters/noctalia.nix

    # ────── Shells ──────
    ./desktop/shells/noctalia.nix

    # ────── Terminals ──────
    ./desktop/terminals/fish.nix

    # ─────────────────────────────────────────────────
    # Hardware
    # ─────────────────────────────────────────────────
    ./hardware/audio.nix
    ./hardware/bluetooth.nix
    ./hardware/intel.nix

    # ─────────────────────────────────────────────────
    # Packages
    # ─────────────────────────────────────────────────

    # ────── Fonts ──────
    ./packages/fonts/fonts.nix

    # ────── Main ──────
    ./packages/main/packages.nix

    # ────── Options ──────
    ./packages/options/defaults.nix
    ./packages/options/integrations.nix

    # ─────────────────────────────────────────────────
    # Services
    # ─────────────────────────────────────────────────
    ./services/arkenfox.nix
    ./services/docker.nix
  ];
}
