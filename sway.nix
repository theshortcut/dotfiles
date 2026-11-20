{ config, lib, pkgs, ... }:
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
    yellow = "#eed49f";
    green = "#a6da95";
    lavender = "#b7bdf8";
    text = "#cad3f5";
    overlay0 = "#6e738d";
    surface2 = "#5b6078";
    surface1 = "#494d64";
    surface0 = "#363a4f";
    base = "#24273a";
    crust = "#181926";
  };

  # Window decoration: border/titlebar background/title text/split indicator/child border.
  window = border: text: indicator: {
    inherit border text indicator;
    background = c.base;
    childBorder = border;
  };

  # i3status-rust block colors: alternating grey pills so neighbouring blocks stay
  # distinct. Overrides idle and info only, so warning (yellow), critical (red) and
  # charging (green) still show through.
  pill = color: {
    idle_bg = color;
    idle_fg = c.text;
    info_bg = color;
    info_fg = c.text;
  };

  # Bar workspace button: border/background/text.
  workspace = background: text: {
    border = c.base;
    inherit background text;
  };

  # Uses the Arch binary since Nix's swaylock can't authenticate via PAM on non-NixOS.
  lock = "/usr/bin/swaylock -f -c 000000";

  # Caffeine: stop swayidle so the screen never locks or blanks, until toggled back.
  # A bare swayidle keeps locking before suspend (e.g. lid close) while it's on.
  # Logging out or rebooting resets it, since swayidle.service starts with the session.
  caffeineSignal = 8; # i3status-rs refreshes the bar pill on SIGRTMIN+8
  caffeineToggle = pkgs.writeShellScript "caffeine-toggle" ''
    if systemctl --user is-active --quiet swayidle.service; then
      systemctl --user stop swayidle.service
      systemd-run --user --quiet --collect --unit=swayidle-caffeine \
        ${lib.getExe config.services.swayidle.package} -w before-sleep '${lock}'
    else
      systemctl --user stop swayidle-caffeine.service 2>/dev/null
      systemctl --user start swayidle.service
    fi
    # Substring match: the Nix wrapper names the process .i3status-rs-wrapped.
    pkill -RTMIN+${toString caffeineSignal} -u "$USER" i3status-rs || true
  '';
  caffeineStatus = pkgs.writeShellScript "caffeine-status" ''
    systemctl --user is-active --quiet swayidle.service || echo "󰅶" # nf-md-coffee
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = null;

    config = {
      modifier = "Mod4";
      terminal = "ghostty";
      menu = lib.getExe config.programs.fuzzel.package;

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

      # Caps Lock acts as Ctrl on every keyboard; Escape stays Escape.
      input."type:keyboard".xkb_options = "ctrl:nocaps";

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

        # Caffeine: keep the screen awake (Mod4+Shift+c is sway's reload)
        "Mod4+Shift+i" = "exec ${caffeineToggle}";
      };

      bars = [
        {
          command = "swaybar";
          # 13.5pt at height 22 makes the rounded cap glyphs fill the bar edge to edge. Other
          # sizes leave flat strips above/below the caps (12, 12.75) or give the glyph a
          # fractional width that shows as a 1px seam beside each cap (12.5).
          fonts = fonts // { size = 13.5; };
          position = "top";
          statusCommand = "${lib.getExe config.programs.i3status-rust.package} ${config.xdg.configHome}/i3status-rust/config-top.toml";
          # Let the powerline blocks fill the full bar height, with a gap before the tray.
          extraConfig = ''
            status_padding 0
            status_edge_padding 0
            height 22
            # Tray: right-click opens the context menu (swaybar defaults it to middle-click),
            # middle-click takes over right-click's old SecondaryActivate.
            tray_bindsym button3 ContextMenu
            tray_bindsym button2 SecondaryActivate
          '';
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

  # Status blocks for swaybar: Catppuccin pills joined by rounded powerline separators.
  # Battery recolors itself by charge level; the clock matches the focused workspace.
  programs.i3status-rust = {
    enable = true;
    bars.top = {
      icons = "material-nf";
      settings.theme = {
        theme = "plain";
        overrides = {
          idle_bg = c.surface0;
          idle_fg = c.text;
          info_bg = c.surface0;
          info_fg = c.text;
          good_bg = c.green;
          good_fg = c.crust;
          warning_bg = c.yellow;
          warning_fg = c.crust;
          critical_bg = c.red;
          critical_fg = c.crust;
          separator = ""; # nerd font U+E0B6, rounded left cap
          end_separator = " "; # nerd font U+E0B4, rounded right cap closing the clock, then a gap before the tray
          separator_bg = "auto";
          separator_fg = "auto";
        };
      };
      blocks = [
        # Current MPRIS track (Spotify, browsers, mpv...) with play/pause and next buttons.
        # Hidden when no player is running; right-click cycles between players.
        {
          block = "music";
          format = "{ $icon $combo.str(max_w:30,rot_interval:0.5) $play $next |}";
          theme_overrides = pill c.surface1;
        }
        # Yellow mic/camera/screen-share icons, shown only while something is capturing.
        {
          block = "privacy";
          driver = [
            { name = "v4l"; }
            { name = "pipewire"; }
          ];
        }
        # Coffee cup while caffeine is on (Mod4+Shift+i); click it to turn it back off.
        {
          block = "custom";
          command = "${caffeineStatus}";
          format = " $text ";
          hide_when_empty = true;
          interval = 30;
          signal = caffeineSignal;
          click = [
            {
              button = "left";
              cmd = "${caffeineToggle}";
              update = true;
            }
          ];
          theme_overrides = {
            idle_bg = c.peach;
            idle_fg = c.crust;
          };
        }
        # Turns yellow/red under sustained load.
        {
          block = "cpu";
          interval = 2;
          format = " $icon $utilization ";
          theme_overrides = pill c.surface0;
        }
        # Shows up/down throughput; click to toggle to SSID/signal.
        {
          block = "net";
          device = "^wlp";
          format = [
            " $icon ^icon_net_down $speed_down.eng(prefix:K) ^icon_net_up $speed_up.eng(prefix:K) "
            " $icon {$ssid $signal_strength|wired} "
          ];
          inactive_format = " $icon off ";
          missing_format = "";
          theme_overrides = pill c.surface1;
        }
        # Scroll to change volume, right-click to mute. Uses the same PulseAudio sink as
        # the volume keys.
        {
          block = "sound";
          driver = "pulseaudio";
          format = " $icon {$volume|muted} ";
          headphones_indicator = true;
          theme_overrides = pill c.surface0;
        }
        # Scroll to adjust; reads the same sysfs device brightnessctl writes.
        {
          block = "backlight";
          format = " $icon $brightness ";
          missing_format = "";
          theme_overrides = pill c.surface1;
        }
        # Charging: green with a charging icon. On AC but full/holding: plug icon.
        # Discharging: grey, then yellow and red as it drains (never green, so the
        # two states can't be confused).
        {
          block = "battery";
          format = " $icon $percentage ";
          charging_format = " $icon $percentage ";
          full_format = " 󰚥 $percentage "; # nf-md-power_plug
          not_charging_format = " 󰚥 $percentage ";
          missing_format = "";
          good = 100; # only reached via charging
          info = 60;
          warning = 30;
          critical = 15;
          theme_overrides = pill c.surface0;
        }
        {
          block = "time";
          interval = 5;
          format = " $icon $timestamp.datetime(f:'%H:%M') ";
          # Matches the focused workspace button.
          theme_overrides = {
            idle_bg = c.mauve;
            idle_fg = c.crust;
          };
        }
      ];
    };
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

  # App launcher: reads .desktop files (incl. Flatpak exports via XDG_DATA_DIRS).
  # Fuzzel colors are RRGGBBAA without the leading #.
  programs.fuzzel = {
    enable = true;
    settings =
      let
        hex = color: lib.removePrefix "#" color + "ff";
      in
      {
        main = {
          font = "Iosevka Nerd Font Mono:size=12";
          terminal = "ghostty -e";
          width = 40;
        };
        colors = {
          background = hex c.base;
          text = hex c.text;
          prompt = hex c.overlay0;
          placeholder = hex c.overlay0;
          input = hex c.text;
          match = hex c.mauve;
          selection = hex c.surface2;
          selection-text = hex c.text;
          selection-match = hex c.mauve;
          border = hex c.mauve;
        };
        border = {
          width = 2;
          radius = 0;
        };
      };
  };

  # Idle: lock at 5 min, screen off at 10 min, lock before suspend. Mod4+Shift+i pauses
  # it (see caffeineToggle).
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = lock; }
      {
        timeout = 600;
        command = "/usr/bin/swaymsg 'output * power off'";
        resumeCommand = "/usr/bin/swaymsg 'output * power on'";
      }
    ];
    events = {
      before-sleep = lock;
    };
  };

  # HM only reloads sway on change when `package` is non-null; do it with the system swaymsg.
  xdg.configFile."sway/config".onChange = ''
    swaySocket="''${XDG_RUNTIME_DIR:-/run/user/$UID}/sway-ipc.$UID.$(/usr/bin/pgrep --uid $UID -x sway || true).sock"
    if [ -S "$swaySocket" ]; then
      /usr/bin/swaymsg -s "$swaySocket" reload
    fi
  '';
}
