{
  # herdr reads ~/.config/herdr/config.toml. Validate with `herdr config check`
  # and apply to a running server with `herdr server reload-config`.
  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [theme]
    name = "catppuccin"
    auto_switch = false

    [keys]
    # Workspace navigation: direct shortcuts, no prefix needed.
    previous_workspace = "alt+k"
    next_workspace = "alt+j"
    switch_workspace = "alt+1..9"
  '';
}
