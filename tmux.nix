{...}:
let
  pkgs = import ( <unstable> ) {};
in
{
  imports = [ "${pkgs.path}/nixos/modules/programs/tmux.nix" ];

  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    keyMode = "vi";
    baseIndex = 1;
    historyLimit = 10000;
    plugins = [ pkgs.tmuxPlugins.nord ];
    terminal = "alacritty";

    extraConfig = ''
      set -g mouse off
      set-window-option -g xterm-keys on
      set-option -a terminal-overrides ",alacritty:RGB"
      set -g pane-active-border-style bg=default,fg=red
      set-option -g default-terminal "alacritty"
    '';
  };
}
