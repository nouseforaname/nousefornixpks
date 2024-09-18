{ config, pkgs , options, lib, services, ... }:
  let
  nixGL = import <nixgl> { };
  nixGLWrap = pkg:
    let
      bin = "${pkg}/bin";
      executables = builtins.attrNames (builtins.readDir bin);
    in
    pkgs.buildEnv {
      name = "nixGL-${pkg.name}";
      paths = map
        (name: pkgs.writeShellScriptBin name ''
          exec -a "$0" ${nixGL.nixGLIntel}/bin/nixGL ${bin}/${name} "$@"
        '')
        executables;
    };
    opkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/7d7622909a38a46415dd146ec046fdc0f3309f44.tar.gz";
    }) {};
  in  
{

  targets.genericLinux.enable =  true;
  nixpkgs.config.allowUnfree = true;
  home= {
    username = "kkiess";
    homeDirectory = "/home/kkiess";
    stateVersion = "22.05";
  };
  programs = {
  # vscode = {
  #   enable = true;
  #   package = pkgs.vscodium;    # You can skip this if you want to use the unfree version
  #   extensions = with pkgs.vscode-extensions; [
  #     # Some example extensions...
  #     dracula-theme.theme-dracula
  #   ];
  #   userSettings = {
  #     javascript.validate.enable = false;
  #     diffEditor.ignoreTrimWhitespace= false;
  #   };
  # };

    fzf = {
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
    bash = {
      enable = true;
      historyControl = ["ignoredups"];
      historyIgnore = ["ls"];
      shellAliases = {
        vpn = "sudo openconnect -u 'kkiess@vmware.com' --protocol=gp gp-ork2.vmware.com -b";
        bcvpn = "sudo openconnect portal.vpn.broadcom.com --protocol=gp -u 'kk016259@broadcom.net' --authgroup='Amsterdam'  --csd-wrapper=/usr/lib/openconnect/hipreport.sh -b
";
        ls = "ls --color=auto";
        ll = "ls -la --color=auto";
        omfly = "nix-shell /home/kkiess/workspace/nousefornixpkg/shells/fly-60.nix";
        boshfly = "nix-shell /home/kkiess/workspace/nousefornixpkg/shells/fly-7.11.2.nix";
        grep = "grep --color=auto";
        code = "codium";
        cat = "bat -pp";
        target_iaas = "x(){ source <(~/workspace/bosh-ecosystem-concourse/bin/iaas-director-print-env $1-director); }; x";
        target_concourse_credhub = "source <(~/workspace/bosh-ecosystem-concourse/bin/concourse-credhub-print-env )";
        preview = "y(){ LINE=$(echo $1 | cut -f2 -d':' ); FILE=$(echo $1 | cut -f1 -d: ); }; y";
        nd = "nix develop path:";
        vimdiff = "vim -d";
      };
      bashrcExtra = builtins.readFile ~/workspace/nousefornixpkg/bashrc;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        add_newline = false;
      };
    };
    git = {
      enable = true;
      userName  = "nouseforaname";
      userEmail = "34882943+nouseforaname@users.noreply.github.com";
      extraConfig = {
        pull = { rebase = true; };
        init = { defaultBranch = "main"; };
        push = { autoSetupRemote = true; };
        commit.verbose = true;
      };
      ignores = [ "*~" ];
      lfs.enable = true;
    };
    home-manager.enable = true;
    neovim = {
      enable = true;
      plugins = with pkgs; with pkgs.vimPlugins;[
        
        # LSPs
        nvim-jdtls
        nvim-lspconfig
        nvim-cmp
        vim-vsnip
        cmp-nvim-lsp
        cmp-vsnip
        cmp-fuzzy-buffer
        #json highlighting
        openconnect
        nvim-tree-lua
#       terraform
#       vim-terraform
#       vim-terraform-completion
        vim-shellcheck 
        #nix expressions
        statix
#       vim-nix

        #general nvim addons
        fzf-vim
        git-blame-nvim
        markdown-preview-nvim
#       vim-json
#       vim-jsonnet
        
      ];
      viAlias = true;
      vimAlias = true;
      extraConfig = builtins.readFile ~/workspace/nousefornixpkg/vimrc;
    };
    direnv = {
      enable = true;
      enableBashIntegration=true;
    };
    
    tmux = {
      enable = true;
      keyMode = "vi";
      baseIndex = 1;
      historyLimit = 10000;
      extraConfig = ''
        set -g mouse off
        set-window-option -g xterm-keys on
        bind-key -n Home send Escape "OH"
        bind-key -n End send Escape "OF"
        
        set -g default-terminal "$TERM"
        set -ag terminal-overrides ",$TERM:Tc" 
      '';
      plugins = with pkgs.tmuxPlugins; [ 
        nord
      ];
    };
    bat = {
      enable = true;
      config = {
        theme = "ansi";
      };
    };
  };

  home.packages = with pkgs; [
    nerdfonts
    tilt
    kiln_branch
    vendir
    entr
    libyaml.dev
    kubectl
    kapp
    #yq
    yq-go
    xq
    jsonnet
    fly79
    nixGL.nixGLIntel
    alacritty
    terraform
    openconnect
    podman
    delve
    vault
    virtualenv
    cmake
    # checkov
    tfsec
    tflint
    ytt
    graphviz
    sshuttle
    ripgrep
    #lastpass-cli
    awscli2
    #azure-cli
    #azure-storage-azcopy
    ( google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ] )
    #credhub_latest
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
    bosh-7-4-0
    credhub-cli
    spruce
    htop
    mod
    godef
    gopls
    gotools
    golangci-lint
    
    counterfeiter
    git-lfs
    ginkgo
    mockgen
    delve
    go_1_22
    firefox
    libtool
    unixtools.netstat
    gcc
    patchelf
    cloudfoundry-cli
    spotify
    libpcap
    libyaml
    postgresql
    libxml2
    libxslt
    pkg-config
    gnumake
    curlFull
    shellcheck
    gh
  ];
  services = {
    lorri.enable = true;
#   keybase = {
#     enable = true;
#   };
#   kbfs =  {
#     enable = true;
#   };
  };

  #fusermount missing
# systemd.user.services.kbfs.Service.Environment = pkgs.lib.mkForce "PATH=/usr/bin:/run/wrappers/bin/:$PATH";
# systemd.user.services.kbfs.Service.ExecStopPost = pkgs.lib.mkForce "/usr/bin/fusermount -u \"%h/keybase\"";
}

