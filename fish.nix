{ pkgs, lib, ...}: {
  programs.fish = {
    enable = true;
    loginShellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end

      fnm env --use-on-cd | source
      '';
    shellAliases = {
      ll = "${pkgs.eza}/bin/eza -lF --color-scale --no-user --no-time --no-permissions --group-directories-first --icons -a";
      ls = "${pkgs.eza}/bin/eza -lF --group-directories-first --icons -a";
      g = "${pkgs.git}/bin/git";
      cat = "${pkgs.bat}/bin/bat --paging=never";
      nvim = "${pkgs.neovim}/bin/nvim";
    };
    shellInit = ''
      set fish_greeting
      set -gx PNPM_HOME $HOME/.pnpm-global
      set -gx PATH $PATH $HOME/.cargo/bin $PNPM_HOME /opt/homebrew/bin/
    '';
    plugins = [
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "79b62958ecf4e87334f24d6743e5766475bcf4d0";
          sha256 = "3d/qL+hovNA4VMWZ0n1L+dSM1lcz7P5CQJyy+/8exTc=";
        };
      }

      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "7f0cf099ae1e1e4ab38f46350ed6757d54471de7";
          sha256 = "4+k5rSoxkTtYFh/lEjhRkVYa2S4KEzJ/IJbyJl+rJjQ=";
        };
      }

      {
        name = "forgit";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          rev = "86dfdf89da6b297f9010d9a6105325f57aa30824";
          sha256 = "fksqsSRROXkgVpt4G54t8KiC7kuEopUzgkv+kllnb/4=";
        };
      }
    ];
  };
}
