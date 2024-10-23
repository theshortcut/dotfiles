{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    escapeTime = 10;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "xterm-256color";
    plugins = with pkgs; [
      { plugin = tmuxPlugins.logging; }
      { plugin = tmuxPlugins.pain-control; }
      { plugin = tmuxPlugins.yank; }
    ];
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
