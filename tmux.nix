{pkgs,...}:{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    historyLimit = 10000;
    plugins = [ pkgs.tmuxPlugins.nord ];

    extraConfig = ''
      set -g mouse off
      set-window-option -g xterm-keys on
      set-option -a terminal-overrides ",alacritty:RGB"
      set -g pane-active-border-style bg=default,fg=red
    '';
  };
}
