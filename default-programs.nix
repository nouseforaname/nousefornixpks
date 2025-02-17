{ ...}:
let
  pkgs = import ( <unstable> ) {};
in
{
  programs = {
    nano.enable = false;
    dconf.enable = true;
    direnv.enable = true;
  }; 
  environment.systemPackages = with pkgs; [
    fzf
    ripgrep
    wget
    bat
  ];
}
