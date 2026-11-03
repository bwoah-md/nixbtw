# icy@nix

Declarative NixOS flake configuration for `icy@nix`, located directly in `~/.config/nixos`.

## Structure

```text
nixos/
├── flake.nix
├── flake.lock
├── hosts/nix/          # Hardware config & system entrypoint
├── modules/            # Modular system configurations & custom packages
└── users/icy/          # User environment, Fish shell, aliases & git
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

### 3. Reboot / Re-log in

Restart your session to ensure all system services, user configurations and shell integrations start correctly.

```bash
reboot
```

## Shell Environment

The user environment is declaratively managed through NixOS.

### Fish Shell

Fish is enabled through `programs.fish`, with the following configuration:

- **Starship** — shell prompt.
- **Television** — fuzzy finder with Fish integration.
- **Zoxide** — smarter directory navigation.
- **Atuin** — shell history with fuzzy search.
- **Helix** — default editor (`EDITOR` and `VISUAL`).

Additional environment variables:

| Variable | Value |
|||
| `EDITOR` | Helix (`hx`) |
| `VISUAL` | Helix (`hx`) |
| `MANPAGER` | bat-based man page viewer |
| `MANROFFOPT` | `-c` |

Fish also includes custom abbreviations and functions for everyday commands, NixOS maintenance, Git, dotfiles, Docker, Windows VM management and phone mounting.

### Shell Abbreviations

**General**
- `btop` — launches btop with forced UTF-8.
- `mf`, `sf`, `tf` — launch Fastfetch with different configurations.
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
- `nixupdate` — update selected custom packages.
- `nixclean` — clean old system and user generations.
- `nixflake` — update selected flake inputs.

**Dotfiles**
- `dot` — navigate to `~/.dotfiles`.
- `dotstatus` — check Git status.
- `dotdiff` — inspect changes.
- `dotadd` — stage all changes.
- `dotpush` — push changes.
- `dotlog` — display formatted Git history.
- `dotremote` — show configured remotes.
- `dotrestore` — copy dotfiles into `~/.config`.

**Docker**
- `docker-start` — start Docker service.
- `docker-stop` — stop Docker service.

**Windows VM**
- `win` — connect to the Windows VM through FreeRDP.
- `win-start` — start Docker and the Windows container.
- `win-stop` — stop the Windows container and Docker.

**Phone**
- `mount-phone` — mount Android internal storage through SSHFS.
- `umount-phone` — unmount phone storage.

### Custom Fish Functions

- `tv-cd` — select a directory using Television and navigate to it (`Alt+T`).
- `help` — display command help using bat.
- `dotcommit` — interactively stage and commit dotfiles changes.
- `nixfrost` — execute the complete NixOS maintenance workflow.

## NixOS Git & Config Workflow

All repository and system maintenance operations are managed using dedicated Fish abbreviations and functions.

### Git Operations

```bash
# Stage changes
nixadd

# Commit changes
nixcommit "commit message"

# Push to GitHub
nixpush

# Pull remote changes
nixpull

# Check repository status
nixstatus
```

### Package & Flake Updates

**Update custom packages:**

```bash
nixupdate
```

Updates:
- Superseedr
- Strata

Also removes the `result` symlink after updating.

**Update selected flake inputs:**

```bash
nixflake
```

Updates:
- nixpkgs
- noctalia
- helium-flake
- winapps
- umbriel
- sonora

### System Maintenance

```bash
# Rebuild and switch using nh
nixrebuild

# Clean old system and user generations
nixclean
```

## Complete One-Shot Sync (`nixfrost`)

`nixfrost` runs the complete maintenance workflow in sequence:

1. Updates Superseedr using `nix-update`.
2. Updates Ghosttime using `nix-update`.
3. Removes the `result` symlink.
4. Updates selected flake inputs.
5. Stages all configuration changes.
6. Rebuilds and switches the NixOS system using `nh`.
7. Commits the changes with an automatic timestamped message.
8. Pushes the commit to GitHub.
9. Cleans old system and user generations.

```bash
nixfrost
```

The generated commit message follows this format:

```text
ran nixfrost at 9 Sep, 2026 at 15:30
```

The workflow uses sequential execution with `and`, so subsequent operations stop if an earlier operation fails.

## Custom Packages

The configuration maintains custom package update workflows under:

```text
modules/packages/
```

The packages updated through the shell helpers are:

- **Superseedr** — updated using `nix-update`.
- **Strata** — updated using `nix-update`.
- **Ghosttime** — updated using `nix-update` during `nixfrost`.

Package definitions are maintained separately from the system package list.

## Additional Integrations

The user environment also includes:

- **Git** — declarative configuration imported through `git.nix`.
- **nh** — NixOS helper for rebuilding and switching configurations.
- **fd** — installed as a system package.
- **Television** — terminal fuzzy finder.
- **Zoxide** — directory navigation.
- **Atuin** — shell history management.
- **Starship** — customizable shell prompt.

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

# System maintenance
nixrebuild
nixclean

# Complete maintenance workflow
nixfrost

# Dotfiles
dotstatus
dotdiff
dotadd
dotcommit
dotpush
```
