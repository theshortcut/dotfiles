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
      ll = "${pkgs.exa}/bin/exa -lF --color-scale --no-user --no-time --no-permissions --group-directories-first --icons -a";
      ls = "${pkgs.exa}/bin/exa -lF --group-directories-first --icons -a";
      g = "${pkgs.git}/bin/git";
      cat = "${pkgs.bat}/bin/bat --paging=never";
      nvim = "${pkgs.neovim}/bin/nvim";
      vim = "${pkgs.neovim}/bin/nvim";
    };
    shellInit = ''
      set fish_greeting
      set -gx PNPM_HOME $HOME/.pnpm-global
      set -gx PATH $PATH $PNPM_HOME
    '';
    plugins = [
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "2fd3d2157d5271ca3575b13daec975ca4c10577a";
          sha256 = "fl4/Pgtkojk5AE52wpGDnuLajQxHoVqyphE90IIPYFU=";
        };
      }

      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "3ee95536106c11073d6ff466c1681cde31001383";
          sha256 = "vyW/X2lLjsieMpP9Wi2bZPjReaZBkqUbkh15zOi8T4Y=";
        };
      }

      {
        name = "forgit";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          rev = "065f7841f334b8707a49ac30d19370aa859db2ed";
          sha256 = "/cqDhHilbMSrzwip+2CGJ9Il4wsx5skyMbqC98hewdc=";
        };
      }
    ];
  };
}
