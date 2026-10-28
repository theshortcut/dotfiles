# Dotfiles.nix

Dotfiles, powered by [Nix](https://nixos.org/nix/) and [home-manager](https://github.com/rycee/home-manager).

## Layout

Every module in `home.nix` is shared. Platform differences live in
`darwin.nix` (macOS) and `linux.nix` (Arch / generic non-NixOS Linux), and
`flake.nix` adds one of them based on the system. Settings like
`programs.fish.loginShellInit` or `programs.ghostty.settings` merge across
modules, so a platform file only has to add or override the parts that differ.

`home-manager switch` picks `clay@<hostname>` if it exists and falls back to
`clay` (the Mac). To add a machine, add a `"clay@<hostname>"` entry in
`flake.nix`.

## How to use (macOS)

1. Install Nix:

   ```bash
   sh <(curl -L https://nixos.org/nix/install)
   ```

1. Enable [Nix Flakes](https://www.tweag.io/blog/2020-05-25-flakes):

   ```bash
   $ mkdir -p ~/.config/nix
   $ cat <<EOF >> ~/.config/nix/nix.conf
   experimental-features = nix-command flakes
   EOF
   $ sudo launchctl kickstart -k system/org.nixos.nix-daemon
   ```

1. Go inside your `~/.config` directory and clone this repo:

   ```bash
   $ mkdir ~/.config && cd ~/.config && \
     git clone https://github.com/theshortcut/dotfiles.git home-manager && cd home-manager
   ```

1. Run the flake and activate your env:

   ```bash
   nix run . && home-manager switch -b backup
   ```

1. Then you can update it with:

   ```bash
   nix flake update && home-manager switch
   ```

## How to use (Arch Linux)

1. Install Nix from the Arch repos, start the daemon, and enable flakes:

   ```bash
   sudo pacman -S nix
   sudo systemctl enable --now nix-daemon.socket
   sudo usermod -aG nix-users $USER   # then log out and back in
   mkdir -p ~/.config/nix
   echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
   ```

1. Install the things that stay outside Nix: `sudo pacman -S fish ghostty`
   (and `docker docker-buildx` if needed: `sudo systemctl enable --now
   docker.socket`, `sudo usermod -aG docker $USER`). Make fish the login
   shell with `chsh -s /usr/bin/fish`.

1. Clone the repo and activate it the same way as on macOS (step 3 onward).
   This machine's hostname must have a `clay@<hostname>` entry in `flake.nix`.

## Prerequisites / assumptions

This config assumes a few things exist on the machine outside of Nix:

- **Git commit signing (SSH):** commits are signed with `~/.ssh/id_ed25519.pub`
  (`programs.git.signing`, `git.nix`). Register that public key on GitHub as a
  **Signing key** (separate from the Authentication key) so commits show as
  Verified. To verify _others'_ signatures locally, add a
  `gpg.ssh.allowedSignersFile`.
- **Neovim config:** `nvim.nix` symlinks `~/src/neovim-config` into
  `~/.config/nvim` via `mkOutOfStoreSymlink`, so that repo must be cloned there.
- **Homebrew (optional):** `/opt/homebrew/bin` is added to `PATH` only if it
  exists, so Homebrew is supported but not required.
