{
  # herdr reads ~/.config/herdr/config.toml. Validate with `herdr config check`
  # and apply to a running server with `herdr server reload-config`.
  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [theme]
    name = "catppuccin"
    auto_switch = false

    [keys]
    # Workspace navigation: prefix+J/K to step, prefix+shift+N to jump
    # (prefix+N is taken by switch_tab).
    previous_workspace = "prefix+shift+k"
    next_workspace = "prefix+shift+j"
    switch_workspace = "prefix+shift+1..9"
  '';
}
