

{ config, pkgs, options, ... }:

{
  programs.home-manager.enable = true;

  home.username = "kkiess";
  home.homeDirectory = "/home/kkiess";
  home.shellAliases = {
   alacritty = "nixGL alacritty";
  };

  home.stateVersion = "22.05";
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ 

    ];
    extraConfig = ''
      set paste
      set tabstop=2
      set expandtab=2
      set shiftwidth=2
      #colorscheme koehler
    '';
  };

  home.packages = with pkgs; [
    chromedriver
    bash-completion
    libmysqlclient
    postgresql
    gdbm
    libffi
    ncurses5
    libyaml
    bison
    openssl
    jq
    readline 
    clang-tools
    bosh
    direnv
    nodenv
    yarn
    chruby
    zlib
    mysql57
    htop
  ];
  programs.bat = {
    enable = true;
  };
  
  programs.chromium.enable = true;

  services.lorri.enable = true;


  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;    # You can skip this if you want to use the unfree version
    extensions = with pkgs.vscode-extensions; [
      # Some example extensions...
      dracula-theme.theme-dracula
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
    bashrcExtra = ''
      source ~/.nix-profile/share/chruby/chruby.sh  && chruby 2.7.6
    '';
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
    };
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
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };
      selection = {
        save_to_clipboard = true;
      };
    };
  };
}

