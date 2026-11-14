{ lib, pkgs, ... }:
let
  # Shared by window titles and the bar; installed via nerd-fonts.iosevka in linux.nix.
  fonts = {
    names = [ "Iosevka Nerd Font Mono" ];
    size = 12.0;
  };

  # Catppuccin Macchiato, matching ghostty's dark theme.
  # https://github.com/catppuccin/catppuccin#-palette
  c = {
    rosewater = "#f4dbd6";
    mauve = "#c6a0f6";
    red = "#ed8796";
    peach = "#f5a97f";
    lavender = "#b7bdf8";
    text = "#cad3f5";
    overlay0 = "#6e738d";
    surface2 = "#5b6078";
    base = "#24273a";
    crust = "#181926";
  };

  # Window decoration: border/titlebar background/title text/split indicator/child border.
  window = border: text: indicator: {
    inherit border text indicator;
    background = c.base;
    childBorder = border;
  };

  # Bar workspace button: border/background/text.
  workspace = background: text: {
    border = c.base;
    inherit background text;
  };
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = null;

    config = {
      modifier = "Mod4";
      terminal = "ghostty";
      menu = "wmenu-run";

      inherit fonts;
      window.titlebar = true;
      floating.titlebar = true;
      focus.wrapping = "yes";

      # Sway names its first workspace after the first `workspace` binding, and HM sorts
      # bindings so Mod4+0 (workspace 10) comes first.
      defaultWorkspace = "workspace number 1";

      output."*".bg = "${c.base} solid_color";
      output.eDP-1.scale = "2";

      colors = {
        background = c.base;
        focused = window c.lavender c.text c.rosewater;
        focusedInactive = window c.overlay0 c.text c.rosewater;
        unfocused = window c.overlay0 c.text c.rosewater;
        urgent = window c.peach c.peach c.overlay0;
        placeholder = window c.overlay0 c.text c.overlay0;
      };

      input."type:touchpad" = {
        natural_scroll = "enabled";
        tap = "enabled";
      };

      keybindings = lib.mkOptionDefault {
        # Volume via PulseAudio
        "--locked XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "--locked XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "--locked XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "--locked XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        # Media via playerctl
        "--locked XF86AudioPlay" = "exec playerctl play-pause";
        "--locked XF86AudioPause" = "exec playerctl play-pause";
        "--locked XF86AudioPrev" = "exec playerctl previous";
        "--locked XF86AudioNext" = "exec playerctl next";
        "--locked XF86AudioStop" = "exec playerctl stop";

        # Brightness via brightnessctl
        "--locked XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "--locked XF86MonBrightnessUp" = "exec brightnessctl set 5%+";

        # Screenshot
        "Print" = "exec grim";
      };

      bars = [
        {
          command = "swaybar";
          inherit fonts;
          position = "top";
          statusCommand = "while date +'%Y-%m-%d %X'; do sleep 1; done";
          colors = {
            background = c.base;
            statusline = c.text;
            separator = c.overlay0;
            focusedWorkspace = workspace c.mauve c.crust;
            activeWorkspace = workspace c.surface2 c.text;
            inactiveWorkspace = workspace c.base c.text;
            urgentWorkspace = workspace c.red c.crust;
            bindingMode = workspace c.peach c.crust;
          };
        }
      ];
    };

    # Arch's drop-ins (systemd/dbus environment import).
    extraConfig = ''
      include /etc/sway/config.d/*

      bindgesture swipe:3:left workspace next_on_output
      bindgesture swipe:3:right workspace prev_on_output
    '';
  };

  # One cursor theme/size for sway, native Wayland apps and XWayland. Size is in logical
  # pixels; sway multiplies by the output scale.
  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    sway.enable = true;
  };

  # HM only reloads sway on change when `package` is non-null; do it with the system swaymsg.
  xdg.configFile."sway/config".onChange = ''
    swaySocket="''${XDG_RUNTIME_DIR:-/run/user/$UID}/sway-ipc.$UID.$(/usr/bin/pgrep --uid $UID -x sway || true).sock"
    if [ -S "$swaySocket" ]; then
      /usr/bin/swaymsg -s "$swaySocket" reload
    fi
  '';
}
