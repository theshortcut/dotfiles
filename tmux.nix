{ pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    shell = "${pkgs.fish}/bin/fish";
    plugins = with pkgs; [
      { plugin = tmuxPlugins.logging; }
      { plugin = tmuxPlugins.pain-control; }
      { plugin = tmuxPlugins.yank; }
    ];
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
