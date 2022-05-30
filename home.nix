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
    plugins = with pkgs.vimPlugins;[  ];
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
    #fly60
    #fly76
    fly77
    ripgrep
    lastpass-cli
    aws
    google-cloud-sdk
    credhub
    chromedriver
    bashInteractive
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
    mod
    godef
    gopls
    solargraph
    unixtools.netstat
    #glibc2_7
    gcc_cust
    #go
    go_1_18
    cloudfoundry-cli
  ];
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    historyLimit = 10000;
    extraConfig = ''
      set -g mouse off
      set-window-option -g xterm-keys on
    '';
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
      "'bat --style=numbers --color=always {}'"
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
      cat = "bat --paging=never -pp --color always";
      vi = "vim";
      target_iaas = "x(){ source <(~/workspace/bosh-ecosystem-concourse/bin/iaas-director-print-env $1-director); }; x";
      preview = "y(){ LINE=$(echo $1 | cut -f2 -d':' ); FILE=$(echo $1 | cut -f1 -d: ); }; y";

    };
    bashrcExtra = ''
      source ~/.nix-profile/share/chruby/chruby.sh  && chruby 2.7.6
      export EDITOR=vi
      #export BASH_COMPLETION_USER_DIR=$HOME/.nix-profile/share/bash-completion/completions
      ssh-add ~/keybase/private/nouseforaname/GITHUB/nouseforaname.pem
      export CGO_LDFLAGS="-Xlinker -rpath=${glibc_path}/lib/ld-linux-x86-64.so.2 -Xlinker --dynamic-linker=/lib64/ld-linux-x86-64.so.2"

      function __file_search {
	RG_PREFIX="rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color \"always\" -g \"*.{js,json,md,styl,html,config,py,cpp,c,go,hs,rb,conf,yml}\" -g '!{.git,node_modules,vendor}/*'"
	INITIAL_QUERY=""
	FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
        fzf \
          --bind "change:reload:$RG_PREFIX {q} || true" \
          --preview 'echo {} | xargs -n 3 -d: bash -c "bat \$0 -r \$1: --highlight-line \$1 --color always --paging never" '  \
	  --ansi --phony --query "$INITIAL_QUERY" | cut -f1-2 -d: | sed 's/:/ +/g'
      }
      function __open_in_vim {
	path=$(__file_search)
	if [[ ! "$path" == "" ]]; then
	  vim -p $path
	fi
      }
      export __open_in_vim
      bind -x '"\C-f":"__open_in_vim"'
      export TERM='xterm-256color'
    '';
  };

  programs.starship = {
    enable = true;
    #enableBashIntegration = true;
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
      commit.verbose = true;
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

