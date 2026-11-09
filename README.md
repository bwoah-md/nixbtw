# icy@nix

###### ⚠️ I have used AI to write some files and to generate this README, and also used it to configure shell functions (in `modules/desktop/terminals/fish.nix`), custom packages (in `modules/packages/main/custom.nix`), and also ArkenFox (in `modules/services/arkenfox.nix`) as I was having tough time and I am still learning.

---

Declarative NixOS flake configuration for `icy@nix`, located directly in `~/.config/nixos`.

## Structure

```text
nixos/
├── flake.nix
├── flake.lock
├── hosts/
│   └── nix/                    # Hardware config & system entrypoint
│       ├── hardware-configuration.nix
│       └── imports.nix         # Master import list
└── modules/
    ├── core/                   # Boot, locale, networking, security, nix settings
    ├── desktop/
    │   ├── compositors/        # Umbriel, labwc, XDG portals
    │   ├── environment/        # Session variables, dconf, gvfs
    │   ├── git/                # System-wide git config
    │   ├── greeters/           # Noctalia greeter
    │   ├── shells/             # Noctalia shell
    │   └── terminals/          # User, Fish shell, abbreviations & functions
    ├── hardware/               # Audio, Bluetooth, Intel graphics & power
    ├── packages/
    │   ├── fonts/              # Font list & custom font packages
    │   ├── main/               # System packages & custom packages
    │   └── options/            # Default apps, fonts & integrations
    └── services/               # Arkenfox updater, Docker
```

## Fresh Machine Setup

### 1. Clone the repository

```bash
git clone https://github.com/bwoah-md/nixbtw.git ~/.config/nixos
```

### 2. Generate Hardware Configuration & Build

```bash
# Generate hardware configuration for the target machine
doas nixos-generate-config --show-hardware-config \
  > ~/.config/nixos/hosts/nix/hardware-configuration.nix

# Switch to the new system configuration
doas nixos-rebuild switch --flake ~/.config/nixos#nix
```

> `doas` is only available once this config has been applied. On a bare
> installer or first boot, use `sudo` for this initial step.

### 3. Reboot / Re-log in

Restart your session so all system services, user configuration and shell integrations start correctly.

```bash
reboot
```

## System Overview

### Core

| Area | Details |
|---|---|
| Bootloader | systemd-boot, limited to 2 generations |
| Kernel | `linuxPackages_latest` |
| Filesystem | Btrfs with `/nix` and `/home` subvolumes |
| Locale | `en_US.UTF-8`, timezone `Asia/Kolkata` |
| Networking | NetworkManager with static Cloudflare DNS (IPv4 & IPv6), firewall enabled |
| Privilege escalation | `doas` (persist enabled), `sudo` disabled |
| Nix | `nix-command` and `flakes` enabled |
| State version | `26.05` |

### Desktop

- **Compositors** — Umbriel (greeter default session) and labwc.
- **Shell** — Noctalia, with its Cachix substituter configured.
- **Greeter** — `noctalia-greeter` autologging into the `umbriel` session for `icy`, using Capitaine cursors.
- **Portals** — GTK default, with ScreenCast and Screenshot routed to `wlr` (labwc) or `umbriel`.
- **Keyring** — GNOME Keyring, unlocked through greetd PAM.
- **Session variables** — Wayland/Ozone enabled, Qt platform theme set to `qt6ct`, `BROWSER=librewolf`, unfree packages allowed.

### Hardware

- **Graphics** — Intel Iris Xe with VA-API, Vulkan and OpenCL support.
- **Audio** — PipeWire (ALSA, PulseAudio compat) with rtkit; forced standard HDA driver for the Realtek ALC236.
- **Bluetooth** — enabled and powered on at boot.
- **Power** — thermald, power-profiles-daemon, upower, and zstd zram swap (50% of RAM).
- **Firmware** — redistributable firmware and Intel microcode updates.

### Services

- **Docker** — enabled but **not started on boot** (`docker-start` / `docker-stop`), with auto-prune.
- **Arkenfox** — weekly user timer that updates the Arkenfox `user.js` for the Firefox profile.

### Git

System-wide Git is configured declaratively in `modules/desktop/git/git.nix`:

- Default branch `main`, `pull.rebase = true`, `push.autoSetupRemote = true`
- Helix as the commit editor
- `credential.helper = store`
- `/etc/nixos` marked as a safe directory

## Shell Environment

The `icy` user and Fish shell are defined in `modules/desktop/terminals/fish.nix`.

### Fish Shell

Fish is enabled through `programs.fish`, with the following integrations:

- **Starship** — shell prompt.
- **Television** — fuzzy finder with Fish integration.
- **Zoxide** — smarter directory navigation.
- **Atuin** — shell history with fuzzy search (sync disabled).
- **nh** — NixOS helper, pointed at `~/.config/nixos`.
- **Helix** — default editor.

Environment variables set in Fish:

| Variable | Value |
|---|---|
| `EDITOR` | Helix (`hx`) |
| `VISUAL` | Helix (`hx`) |
| `MANPAGER` | bat-based man page viewer |
| `MANROFFOPT` | `-c` |
| `PATH` | `~/.local/bin` prepended |

### Shell Abbreviations

**General**
- `btop` — launches btop with forced UTF-8.
- `mf`, `sf`, `tf` — Fastfetch (micro / small / tiny configs).
- `c` — clear terminal.

**bat / eza**
- `cat` — bat without paging.
- `bathelp` — display help output using bat.
- `ls`, `ll`, `la`, `lt` — eza shortcuts.

**NixOS**
- `nixadd` — stage all repository changes.
- `nixcommit` — commit with a supplied message.
- `nixpush` — push to GitHub.
- `nixpull` — pull from GitHub.
- `nixstatus` — check repository status.
- `nixrebuild` — rebuild and switch using nh.
- `nixupdate` — update custom packages (Superseedr).
- `nixclean` — clean old system and user generations.
- `nixflake` — update selected flake inputs.
- `nixcachix` — update Cachix-backed flake inputs (Nixpkgs, Strata and Cressida).

**Dotfiles**
- `dot` — navigate to `~/.dotfiles`.
- `dotstatus` — check Git status.
- `dotdiff` — inspect changes.
- `dotadd` — stage all changes.
- `dotpush` — push changes.
- `dotlog` — formatted Git history.
- `dotremote` — show configured remotes.
- `dotrestore` — copy dotfiles into `~/.config`.

**Docker**
- `docker-start` — start the Docker service.
- `docker-stop` — stop the Docker service.

**Windows VM**
- `win` — connect to the Windows VM through FreeRDP.
- `win-start` — start Docker and the Windows container.
- `win-stop` — stop the Windows container and Docker.

**Phone**
- `mount-phone` — mount Android internal storage through SSHFS.
- `umount-phone` — unmount phone storage.

### Custom Fish Functions

- `tv-cd` — select a directory using Television and `cd` into it (`Alt+T`).
- `help` — display command help using bat.
- `dotcommit` — interactively stage and commit dotfiles changes.

## NixOS Git & Config Workflow

```bash
nixadd                      # Stage changes
nixcommit "commit message"  # Commit changes
nixpush                     # Push to GitHub
nixpull                     # Pull remote changes
nixstatus                   # Check repository status
```

### Package & Flake Updates

**Update custom packages:**

```bash
nixupdate
```

Updates **Superseedr** with `nix-update`, then removes the `result` symlink.

**Update Cachix-backed flake inputs:**

```bash
nixcachix
```

Updates `nixpkgs`, `strata` and `cressida`.

**Update other selected flake inputs:**

```bash
nixflake
```

Updates: `nixpkgs`, `noctalia`, `helium-flake`, `winapps`, `umbriel`, `sonora`.

### System Maintenance

```bash
nixrebuild   # nh os switch -H nix
nixclean     # doas nix-collect-garbage -d && nix-collect-garbage -d
```

## Custom Packages

Custom package definitions live in `modules/packages/main/custom.nix` and are exposed both as flake `packages.x86_64-linux.*` (so `nix-update --flake` works) and as system packages:

- **Superseedr** — Rust build from source, updated with `nix-update`.

Custom fonts live separately in `modules/packages/fonts/custom.nix`:

- **Google Sans Flex** — default sans-serif font.

## Packages & Defaults

System packages are grouped by category in `modules/packages/main/packages.nix` (shell tools, editors, browsers, media, theming, development, etc.), with unused packages kept as comments for quick toggling.

**Default apps and fonts** (`modules/packages/options/defaults.nix`):

| Role | Value |
|---|---|
| Browser | LibreWolf |
| File manager | Strata |
| Monospace | Annotation Mono |
| Sans-serif | Google Sans Flex |
| Serif | IBM Plex Serif |
| Emoji | Noto Color Emoji |

**Integrations** (`modules/packages/options/integrations.nix`):

- **OBS Studio** — virtual camera plus wlrobs, VAAPI, vkcapture and PipeWire audio capture plugins.
- **LocalSend** — firewall opened, wrapped for Wayland with a hidden title bar.
- **KDE Connect**, **nix-ld**, **GNOME Keyring**.
- **Helium browser** — Ozone auto-detection and touchpad overscroll navigation.

## Flake Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | `nixos-unstable` |
| `noctalia` | Shell and greeter modules |
| `umbriel` | Compositor module |
| `helium-flake` | Helium browser (follows `nixpkgs`) |
| `sonora` | Sonora app (`sonora-bin`) |
| `winapps` | WinApps (follows `nixpkgs`) |
| `strata` | Strata file manager and file chooser portal |
| `cressida` | Cressida application |

## Useful Commands

```bash
# Repository
nixstatus
nixadd
nixcommit "message"
nixpush
nixpull

# Custom packages
nixupdate

# Flake inputs
nixflake
nixcachix

# System maintenance
nixrebuild
nixclean

# Dotfiles
dotstatus
dotdiff
dotadd
dotcommit
dotpush
```
