let
  pkgs_glibc_2_7 = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/2158ec610d90359df7425e27298873a817b4c9dd.tar.gz";
  }) {};
  pkgs_bintools = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/559cf76fa3642106d9f23c9e845baf4d354be682.tar.gz";
  }) {};
  binutils-unrwapped2_7 = pkgs_bintools.binutils;
  glibc2_7 = pkgs_glibc_2_7.glibc;
  gcc_cust = 
    pkgs_bintools.wrapCCWith {
      cc = pkgs_bintools.gcc-unwrapped;
      bintools = pkgs_bintools.wrapBintoolsWith {
        bintools = pkgs_bintools.binutils-unwrapped;
        libc = glibc2_7;
      };
    };
  glibc_path = glibc2_7.outPath;

in
{ config, pkgs, options, lib, services, ... }:

{
  programs.home-manager.enable = true;

  home.username = "kkiess";
  home.homeDirectory = "/home/kkiess";
  home.stateVersion = "22.05";
  programs.neovim = {
    enable = true;
    coc = {
      enable = true;
      package = pkgs.vimPlugins.LanguageClient-neovim;
    };
    plugins = with pkgs.vimPlugins;[ 
      LanguageClient-neovim
      nvim-fzf
      vim-go
      vim-ruby
      deoplete-nvim
      deoplete-lsp
      deoplete-go
    ];
    viAlias = true;
    vimAlias = true;
    extraConfig = ''

      " GENERAL SETTINGS

      set tabstop=2
      set expandtab
      set shiftwidth=2
      set mouse-=a
      set noautoindent
      set nocindent
      set nosmartindent
      colorscheme koehler
      


      " LSP 
      let g:LanguageClient_autoStart = 1
      let g:LanguageClient_autoStop = 1
      let g:LanguageClient_hasSnippetSupport = 1
      let g:LanguageClient_loadSettings = 1

      " GOLANG

      " autoimports
      let g:go_fmt_command = "goimports"

      let g:LanguageClient_serverCommands = {
       \ 'go': ['gopls']
       \ }
      
      " Run gofmt on save
      autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

      " Use deoplete.
      let g:deoplete#enable_at_startup = 1
      call deoplete#custom#option('omni_patterns', {
      \ 'go': '[^. *\t]\.\w*',
      \})

    '';
  };
  
  home.packages = with pkgs; [
    #fly60
    #fly76
    #clang
    fly77
    sshuttle
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
    ncurses5
    libyaml
    bison
    openssl
    jq
    readline 
    coreutils
    #bosh-6-4-17
    bosh-7-0-0
    direnv
    nodenv
    yarn
    chruby
    libffi
    zlib
    zlib.dev
    zlib-ng
    libxml2
    mysql57
    curlFull
    htop
    ginkgo
    mod
    godef
    gopls
    gocode
    golangci-lint
    msgpack #deoplete dep
    solargraph
    libtool
    unixtools.netstat
    #glibc2_7
    gcc_cust
    #ruby
    #go
    go_1_18
    cloudfoundry-cli
    ruby_3_1.devEnv
    #gcc

  ];
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    historyLimit = 10000;
    extraConfig = ''
      set -g mouse off
      set-window-option -g xterm-keys on
      set-option -sa terminal-overrides ',XXX:RGB'
      set-option -sg escape-time 10
      bind-key -n Home send Escape "OH"
      bind-key -n End send Escape "OF"
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
      target_iaas = "x(){ source <(~/workspace/bosh-ecosystem-concourse/bin/iaas-director-print-env $1-director); }; x";
      preview = "y(){ LINE=$(echo $1 | cut -f2 -d':' ); FILE=$(echo $1 | cut -f1 -d: ); }; y";
    };
    bashrcExtra = ''
      source ~/.nix-profile/share/chruby/chruby.sh
      export EDITOR=nvim
      #export BASH_COMPLETION_USER_DIR=$HOME/.nix-profile/share/bash-completion/completions
      ssh-add ~/keybase/private/nouseforaname/GITHUB/nouseforaname.pem
      export CGO_LDFLAGS="-Xlinker -rpath=${glibc_path}/lib/ -Xlinker --dynamic-linker=/lib64/ld-linux-x86-64.so.2"

      function __file_search {
        RG_PREFIX="rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color \"always\" -g \"*.{js,json,md,styl,html,config,py,cpp,c,go,hs,rb,conf,yml}\" -g '!{.git,node_modules,vendor}/*'"
        INITIAL_QUERY=""
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
          fzf \
            --bind "change:reload:$RG_PREFIX {q} || true" \
            --preview 'echo {} | xargs -n 4 -d: bash -c "LINE=\$1; if [[ \$LINE -gt 25 ]]; then PREV_LINE=\$((\$LINE-25)); else PREV_LINE=0; fi; bat \$0 -r \$PREV_LINE: --highlight-line \$1 --color always --paging never"'  \
            --ansi --phony --query "$INITIAL_QUERY" | cut -f1-2 -d: | sed 's/:/ +/g'
      }
      function __open_in_vim {
        path=$(__file_search)
        if [[ ! "$path" == "" ]]; then
          nvim -p $path
        fi
      }
      export __open_in_vim
      bind -x '"\C-f":"__open_in_vim"'
      export TERM='screen'
     #export LIBRARY_PATH+=${pkgs.zlib}/lib:${pkgs.zlib-ng}/lib:${pkgs.libxml2}/lib
     #export LD_LIBRARY_PATH+=${pkgs.zlib}/lib:${pkgs.zlib-ng}/lib:${pkgs.libxml2}/lib:${pkgs.libffi}/lib
     #export LDFLAGS="-Xlinker,-Wl,-rpath,${glibc_path}/lib/"
     #export C_INCLUDE_PATH+=${pkgs.zlib.dev}/include
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
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

