{ config, pkgs, options, lib, services, ... }:
let 
  deoplete-tabnine-cust = pkgs.vimPlugins.deoplete-tabnine.overrideAttrs(old: {
    postPatch = ''
      substituteInPlace rplugin/python3/deoplete/sources/tabnine.py \
        --replace "path = get_tabnine_path(binary_dir)" "path = '${pkgs.tabnine}/bin/TabNine'"
    '';
  });
in  
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "tabnine"
  ];

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
    plugins = with pkgs; with pkgs.vimPlugins;[
      LanguageClient-neovim
      nvim-fzf
      vim-go
      # general deoplete for completion
      deoplete-nvim
      deoplete-lsp
      deoplete-dictionary
      # deo git
      deoplete-github
      # deoplete golang
      deoplete-go
      # deoplete javascript
      deoplete-ternjs

      #deoplete ruby
      deoplete-tabnine-cust
      
      #nix expressions
      statix
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
        \ 'go': ['gopls'],
        \ 'ruby': ['solargraph']
      \ }
      
      " Run gofmt on save
      autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

      " Use deoplete.
      let g:deoplete#enable_at_startup = 1

      call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])
      call deoplete#custom#source('ultisnips', 'rank', 1000)
      call deoplete#custom#source('syntax', 'rank', 100)

      " go completion

      call deoplete#custom#option('omni_patterns', {
      \ 'go': '[^. *\t]\.\w*',
      \ 'ruby': ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
      \})

      " ruby autocomplete
     "call deoplete#custom#var('tabnine', {
     "\ 'line_limit': 500,
     "\ 'max_num_results': 20,
     "\ })
    '';
  };
  
  home.packages = with pkgs; [
    #fly60
    fly78
    #fly77
    ytt
    bosh-bootloader
    sshuttle
    ripgrep
    lastpass-cli
    awscli
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
    nodenv
    yarn
    curlFull
    htop
    #ginkgo
    mod
    godef
    gopls
    gocode
    golangci-lint
    msgpack #deoplete dep
#   bundix
#   solargraph
    libtool
    unixtools.netstat
    gcc
    patchelf
    go_1_18
    cloudfoundry-cli
    tabnine
    #javascript
  ];
  programs.direnv = {
    enable = true;
    enableBashIntegration=true;
  };
  
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
    #shell = "${pkgs.bashInteractive}/bin/bash";
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
    };
    
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
    enableBashIntegration = true;
    tmux.enableShellIntegration = true;
    
    fileWidgetCommand = "rg --files --hidden ./ -g \"!{.cache,.nix-*,.gem}\"";
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
      cat = "bat -pp";
      target_iaas = "x(){ source <(~/workspace/bosh-ecosystem-concourse/bin/iaas-director-print-env $1-director); }; x";
      preview = "y(){ LINE=$(echo $1 | cut -f2 -d':' ); FILE=$(echo $1 | cut -f1 -d: ); }; y";
    };
    bashrcExtra = ''
      export EDITOR=nvim
      ssh-add ~/keybase/private/nouseforaname/GITHUB/nouseforaname.pem


      function __file_search {
        RG_PREFIX="rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color \"always\" -g '!{.git,node_modules,vendor,.bosh}/*'"
        INITIAL_QUERY=""
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
          fzf \
            --bind "change:reload:$RG_PREFIX {q} || true" \
            --preview 'echo {} | xargs -n 4 -d: bash -c "LINE=\$1; if [[ \$LINE -gt 25 ]]; then PREV_LINE=\$((\$LINE-25)); else PREV_LINE=0; fi; bat \$0 -r \$PREV_LINE: --highlight-line \$LINE --color always --paging never"'  \
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

