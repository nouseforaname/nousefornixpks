let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/2158ec610d90359df7425e27298873a817b4c9dd.tar.gz";
  }) {};
  glibc2_7 = pkgs.glibc;
  gcc_cust = pkgs.gcc.override {
    libc = glibc2_7;
    bintools = pkgs.binutils.override {
      libc = glibc2_7;
    };
  };
  glibc_path = pkgs.glibc.outPath;

in
{ config, pkgs, options, lib, services, ... }:

{
  programs.home-manager.enable = true;

  home.username = "kkiess";
  home.homeDirectory = "/home/kkiess";
  home.stateVersion = "22.05";
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ 

    ];
    extraConfig = ''
      set paste
      set tabstop=2
      set expandtab
      set shiftwidth=2
      set mouse-=a
      set ttymouse-=a
      colorscheme koehler
    '';
  };
  
  home.packages = with pkgs; [
    fly60
    aws
    google-cloud-sdk
    credhub
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
    coreutils
    bosh
    direnv
    nodenv
    yarn
    chruby
    zlib
    mysql57
    htop
    ginkgo
    godef
    gopls
    solargraph
    unixtools.netstat
    #glibc2_7
    gcc_cust
    #go
    go_1_18
  ];
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    #newSession = true;
    shell = "${pkgs.bashInteractive}/bin/bash";
  };
  programs.bat = {
    enable = true;
  };
# services.postgresql = {
#   enable = true;
#   package = pkgs.postgresql_13;
#   enableTCPIP = true;
#   authentication = pkgs.lib.mkOverride 10 ''
#     local all all trust
#     host all all 127.0.0.1/32 trust
#     host all all ::1/128 trust
#   '';
#   initialScript = pkgs.writeText "backend-initScript" ''
#     CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
#     CREATE DATABASE nixcloud;
#     GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
#   '';
# };


  programs.chromium.enable = true;

  services.lorri.enable = true;


  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;    # You can skip this if you want to use the unfree version
    extensions = with pkgs.vscode-extensions; [
      # Some example extensions...
      dracula-theme.theme-dracula
    ];
    userSettings = {
      javascript.validate.enable = false;
      diffEditor.ignoreTrimWhitespace= false;
    };
  };

  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;

    fileWidgetCommand = "rg --files --hidden ./";
    fileWidgetOptions = [ 
      "--preview"
      "'bat --style=numbers --color=always --line-range :500 {}'"
    ];

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
      cat = "bat --paging=never";
      vi = "vim";
      target_iaas = "x(){ source <(~/workspace/bosh-ecosystem-concourse/bin/iaas-director-print-env $1-director); }; x";
    };
    bashrcExtra = ''
      source ~/.nix-profile/share/chruby/chruby.sh  && chruby 2.7.6
      export EDITOR=vi
      eval "$(starship init bash)"
      export FZF_CTRL_T_COMMAND="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
      export BASH_COMPLETION_USER_DIR=$HOME/.nix-profile/share/bash-completion/completions
      ssh-add ~/keybase/private/nouseforaname/GITHUB/nouseforaname.pem
      export CGO_LDFLAGS="-Xlinker --dynamic-linker=${glibc_path}"
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

