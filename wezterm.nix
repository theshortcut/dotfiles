{ pkgs, ... }: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      -- wezterm.gui is not available to the mux server, so take care to
      -- do something reasonable when this config is evaluated by the mux
      function get_appearance()
        if wezterm.gui then
          return wezterm.gui.get_appearance()
        end
        return 'Dark'
      end

      function scheme_for_appearance(appearance)
        if appearance:find 'Dark' then
          return 'Tokyo Night'
        else
          return 'Tokyo Night Day'
        end
      end

      return {
        color_scheme = scheme_for_appearance(get_appearance()),
        font = wezterm.font("Iosevka Nerd Font Mono"),
        font_size = 14.0,
        front_end = "WebGpu",
        hide_tab_bar_if_only_one_tab = true,
        window_decorations = "RESIZE",
        window_background_opacity = 0.98,
      }
    '';
  };
}
