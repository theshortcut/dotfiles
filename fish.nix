{ pkgs, ... }:
{
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
      set -gx PATH $HOME/.cargo/bin $PNPM_HOME/bin $HOME/.opencode/bin $PATH
      if test -d /opt/homebrew/bin
        fish_add_path /opt/homebrew/bin
      end
    '';
    # Plugin sources are pinned by nixpkgs and move with `nix flake update`.
    plugins = [
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
    ];
  };
}
