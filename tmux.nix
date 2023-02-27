{ pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    plugins = with pkgs; [
      { plugin = tmuxPlugins.logging; }
      { plugin = tmuxPlugins.copycat; }
      { plugin = tmuxPlugins.pain-control; }
      { plugin = tmuxPlugins.yank; }
    ];
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
