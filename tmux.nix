{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    escapeTime = 10;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    plugins = with pkgs; [
      { plugin = tmuxPlugins.logging; }
      { plugin = tmuxPlugins.pain-control; }
      { plugin = tmuxPlugins.yank; }
    ];
    extraConfig = ''
      # workaround https://github.com/nix-community/home-manager/issues/5952
      set -gu default-command
      set -g default-shell "$SHELL"

      # True color (24-bit) passthrough for the outer terminal (Ghostty).
      # tmux advertises tmux-256color internally (see `terminal`); this tells
      # it the outer terminal supports RGB. Add more terminals as needed.
      set -as terminal-features ",xterm-ghostty:RGB"

      # Vim style key bindings
      set -g @shell_mode 'vi'
      set-window-option -g mode-keys vi
      bind-key -Tcopy-mode-vi 'v' send -X begin-selection

      # Status config
      # Powerline glyphs:
      set -g status-style "fg=colour5,bg=colour238"
      set -g status-left "#[fg=colour238,bg=colour3,bold] #h #[fg=colour3,bg=colour6]#[fg=colour238,bg=colour6] #S #[fg=colour6,bg=colour238] "
      set -g status-left-length 32
      set -g status-right "#[fg=#586e75]#[fg=#002b36,bg=#586e75] %d %b %R "
      set -g status-right-length 50
      setw -g window-status-style "fg=colour240,bg=colour238"
      setw -g window-status-current-style "fg=colour238,bg=colour238"
      setw -g window-status-separator ""
      setw -g window-status-format "#[fg=default,bg=colour238] #I  #[fg=default]#W "
      setw -g window-status-current-format "#[fg=colour238,bg=colour2]#[fg=colour238,bg=colour2] #I  #[bold]#W #[fg=colour2,bg=colour238,nobold]"
    '';
  };
}
