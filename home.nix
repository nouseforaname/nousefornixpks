{ config, pkgs , options, lib, services, ... }:
# let 
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
      # 
      markdown-preview-nvim
      # LSPs
      LanguageClient-neovim
      fzf-vim
      fzf-lsp-nvim
      vim-nix
      vim-go
      vim-jsonnet
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      deoplete-nvim
      deoplete-lsp


      #terraform
      vim-terraform
      vim-terraform-completion
      
      #nix expressions
      statix

      #git blame
      git-blame-nvim

    ];
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ~/workspace/nousefornixpkg/vimrc;
  };
  
  home.packages = with pkgs; [
    entr
    libyaml.dev
    kubectl
    kapp
    #yq
    yq-go
    xq
    jsonnet
    #fly79
     fly78
    terraform
    vault
    virtualenv
    cmake
    # checkov
    tfsec
    tflint
    ytt
    bosh-bootloader
    sshuttle
    ripgrep
    #lastpass-cli
    awscli2
    #azure-cli
    #azure-storage-azcopy
    ( google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ] )
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
    bosh-7-2-3
    nodenv
    yarn
    #curlFull
    htop
    mod
    godef
    gopls
    gocode
    golangci-lint
    delve
    go_1_20
    slack
    firefox
    libtool
    unixtools.netstat
    gcc
    patchelf
    cloudfoundry-cli
    tabnine
    spotify
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
    bashrcExtra = builtins.readFile ~/workspace/nousefornixpkg/bashrc;
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
    userEmail = "user.email=34882943+nouseforaname@users.noreply.github.com";
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

