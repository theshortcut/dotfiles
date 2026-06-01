# Dotfiles.nix

Dotfiles, powered by [Nix](https://nixos.org/nix/) and [home-manager](https://github.com/rycee/home-manager).

## How to use

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
