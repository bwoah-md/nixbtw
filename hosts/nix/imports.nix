{ ... }:

{
  imports = [
    # ─────────────────────────────────────────────────
    # Hardware Configuration
    # ─────────────────────────────────────────────────
    ./hardware-configuration.nix

    # ─────────────────────────────────────────────────
    # Core
    # ─────────────────────────────────────────────────
    ../../modules/core/boot.nix
    ../../modules/core/global.nix
    ../../modules/core/locale.nix
    ../../modules/core/networking.nix
    ../../modules/core/security.nix

    # ─────────────────────────────────────────────────
    # Desktop
    # ─────────────────────────────────────────────────

    # ────── Compositors ──────
    ../../modules/desktop/compositors/umbriel.nix
    # ../../modules/desktop/compositors/labwc.nix

    # ────── Environment ──────
    ../../modules/desktop/environment/integration.nix
    ../../modules/desktop/environment/variables.nix

    # ────── Git ──────
    ../../modules/desktop/git/git.nix

    # ────── Greeters ──────
    ../../modules/desktop/greeters/noctalia.nix

    # ────── Shells ──────
    ../../modules/desktop/shells/noctalia.nix

    # ────── Terminals ──────
    ../../modules/desktop/terminals/fish.nix

    # ─────────────────────────────────────────────────
    # Hardware
    # ─────────────────────────────────────────────────
    ../../modules/hardware/audio.nix
    # ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/intel.nix

    # ─────────────────────────────────────────────────
    # Packages
    # ─────────────────────────────────────────────────

    # ────── Main ──────
    ../../modules/packages/main/fonts.nix
    ../../modules/packages/main/packages.nix

    # ────── Options ──────
    ../../modules/packages/options/defaults.nix
    ../../modules/packages/options/integrations.nix

    # ─────────────────────────────────────────────────
    # Services
    # ─────────────────────────────────────────────────
    # ../../modules/services/arkenfox.nix
    ../../modules/services/docker.nix
  ];

  system.stateVersion = "26.05";
}
