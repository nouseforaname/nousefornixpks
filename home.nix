{ config, pkgs , options, lib, services, ... }:
# let 
#   deoplete-tabnine-cust = pkgs.vimPlugins.deoplete-tabnine.overrideAttrs(old: {
#     postPatch = ''
#       substituteInPlace rplugin/python3/deoplete/sources/tabnine.py \
#         --replace "path = get_tabnine_path(binary_dir)" "path = '${pkgs.tabnine}/bin/TabNine'"
#     '';
#    });
#  # opkgs = import (builtins.fetchTarball {
#  #   url = "https://github.com/NixOS/nixpkgs/archive/d1c3fea7ecbed758168787fe4e4a3157e52bc808.tar.gz";
#  # }) {};
#  # inherit (opkgs) go_1_16;
# in  
{
  targets.genericLinux.enable =  true;
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
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
      fzf-vim
      fzf-lsp-nvim
      vim-nix
      vim-go
      vim-jsonnet
      nvim-lspconfig

      #terraform
      vim-terraform
      vim-terraform-completion
      
      #nix expressions
      statix
    ];
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set clipboard=unnamedplus

      " KEY BINDINGS
      autocmd FileType go nmap <leader>d  <Plug>(go-def)
      autocmd FileType go nmap <leader>D  <Plug>(go-def-pop)
      autocmd FileType go nmap gu  :GoReferrers<CR>

      " gf for file search
      nnoremap ff :Files<CR>


      " GENERAL SETTINGS
      set tabstop=2
      set expandtab
      set shiftwidth=2
      set mouse-=a
      set noautoindent
      set nocindent
      set nosmartindent
      set nu
      colorscheme koehler
      

      " LSP 
      let g:LanguageClient_autoStart = 1
      let g:LanguageClient_autoStop = 0
      let g:LanguageClient_hasSnippetSupport = 1
      let g:LanguageClient_loadSettings = 1

      let g:LanguageClient_serverCommands = {
        \ 'go': ['gopls'],
        \ 'ruby': ['solargraph', 'stdio']
      \ }

      " GOLANG

      " autoimports
      let g:go_fmt_command = "goimports"

      " Run gofmt on save
      autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
      
      " Linting
      let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck','revive','staticcheck','unused','varcheck']
      let g:go_metalinter_autosave = 1

      " show type info
      let g:go_auto_type_info = 1
      " highlighting

      let g:go_highlight_types = 1
      let g:go_highlight_fields = 1
      let g:go_highlight_function_calls = 1
      let g:go_highlight_operators = 1
      let g:go_highlight_extra_types = 1
      let g:go_highlight_build_constraints = 1

      autocmd FileType ruby nnoremap <F5> :call LanguageClient_contextMenu()<CR>
      autocmd FileType ruby nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
      autocmd FileType ruby nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
      autocmd FileType ruby nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

    '';
  };
  
  home.packages = with pkgs; [
    kubectl
    kapp
    #yq
    yq-go
    jsonnet
    #fly60
    fly78
    #fly77
    terraform
    virtualenv
    # checkov
    tfsec
    tflint
    ytt
    bosh-bootloader
    sshuttle
    ripgrep
    lastpass-cli
    awscli
    azure-cli
    azure-storage-azcopy
    google-cloud-sdk
    credhub_latest
    chromedriver
    bashInteractive
    bash-completion
    libmysqlclient
    postgresql
    nix-prefetch-git
    gdbm
    ncurses5
    libyaml
    bison
    openssl
    jq
    readline 
    coreutils
    #bosh-6-4-17
    bosh-7-0-1
    nodenv
    yarn
    curlFull
    htop
    mod
    godef
    gopls
    gocode
    golangci-lint
    go_1_19
    slack
    firefox
    libtool
    unixtools.netstat
    gcc
    patchelf
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
    enableZshIntegration = false;
    enableFishIntegration = false;
    fileWidgetCommand = "rg --files --hidden ./ -g '!*{.git,.cache,.nix-*,.gem,vendor,gems,tmp}*' ";
    changeDirWidgetCommand = "find ~/workspace -type d | sed 's#.*kkiess#\${HOME}#'";
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
      omfly = "nix-shell /home/kkiess/workspace/nousefornixpkg/shells/fly-60.nix";
      grep = "grep --color=auto";
      code = "codium";
      cat = "bat -pp";
      target_iaas = "x(){ source <(~/workspace/bosh-ecosystem-concourse/bin/iaas-director-print-env $1-director); }; x";
      target_concourse_credhub = "source <(~/workspace/bosh-ecosystem-concourse/bin/concourse-credhub-print-env )";
      preview = "y(){ LINE=$(echo $1 | cut -f2 -d':' ); FILE=$(echo $1 | cut -f1 -d: ); }; y";
    };
    bashrcExtra = ''
      export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}
      export EDITOR=nvim
      ssh-add ~/keybase/private/nouseforaname/GITHUB/nouseforaname.pem
      source <(kubectl completion bash)
      alias vpn='gpu -c'


      function __file_search {
        RG_PREFIX="rg --line-number -S --no-heading --ignore-case --no-ignore --hidden --follow -g \"!{.git,node_modules,vendor,.bosh,tmp}/*\" -g \"!*/{.git,node_modules,vendor,.bosh,tmp}/*\""
        INITIAL_QUERY=""
        FZF_DEFAULT_COMMAND="$RG_PREFIX \"''${INITIAL_QUERY}\" | cut -f1-2 -d: " \
          fzf \
            --bind "change:reload:$RG_PREFIX {q} | cut -f1-2 -d: || true" \
            --preview 'echo {} | xargs -n 3 -d: bash -c "LINE=\$1; if [[ \$LINE -gt 25 ]]; then PREV_LINE=\$((\$LINE-25)); else PREV_LINE=0; fi; bat \$0 -r \$PREV_LINE: --highlight-line \$LINE:\$LINE --color always --paging never"'  \
            --ansi --phony --query "$INITIAL_QUERY" | sed 's/:/ +/g'
      }
      function __open_in_vim {
        path=$(__file_search)
        if [[ ! "$path" == "" ]]; then
          history -s "nvim -p $path"
          nvim -p $path
        fi
      }
      export __open_in_vim
      bind -x '"\C-f":"__open_in_vim"'
      export TERM='screen'
      export PATH=$PATH:~/workspace/services-enablement-home/bin:~/go/bin
      source ~/workspace/services-enablement-home/bin/target-csb-func
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
    };
  };
  programs.git = {
    enable = true;
    userName  = "nouseforaname";
    userEmail = "kkiess@vmware.com";
    extraConfig = {
      pull = { rebase = true; };
      init = { defaultBranch = "main"; };
      push = { autoSetupRemote = true; };
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

