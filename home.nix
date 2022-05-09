{ config, pkgs, options, ... }:

{
  home.sessionVariables = { 
    PATH = "/run/wrappers/bin/:$PATH";
  };
  programs.home-manager.enable = true;

  home.username = "kkiess";
  home.homeDirectory = "/home/kkiess";
  home.shellAliases = {
   alacritty = "nixGL alacritty";
  };

  home.stateVersion = "22.05";

  home.packages = with pkgs; [
    jq
    gcc 
    clang-tools
    bosh
    direnv
  ];
  programs.bat = {
    enable = true;
  };
  services.lorri.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;    # You can skip this if you want to use the unfree version
    extensions = with pkgs.vscode-extensions; [
      # Some example extensions...
      dracula-theme.theme-dracula
      vscodevim.vim
    ];
  };

  programs.fzf = {
    enable = true;
  };
  programs.bash = {
    enable = true;
    historyControl = ["ignoredups"];
    historyIgnore = ["ls"];
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -la --color=auto";
      grep = "grep --color=auto";
      code = "codium";
    };
  };
  programs.starship = {
    enable = true;
  };
  programs.git = {
    enable = true;
    userName  = "nouseforaname";
    userEmail = "kkiess@vmware.com";
    extraConfig = {
      pull = { rebase = true; };
      init = { defaultBranch = "main"; };
    };
    ignores = [ "*~" ];
    lfs.enable = true;
  };
  services.keybase = {
    enable = true;
  };
  services.kbfs =  {
    enable = true;
  };
  #fusermount missing
  systemd.user.services.kbfs.Service.Environment = pkgs.lib.mkForce "PATH=/usr/bin:/run/wrappers/bin/:$PATH";
  systemd.user.services.kbfs.Service.ExecStopPost = pkgs.lib.mkForce "/usr/bin/fusermount -u \"%h/keybase\"";

  programs.alacritty = {
    enable = true;
    
  };

# imports = [
#   "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/dell/precision/5530"
# ];

}

