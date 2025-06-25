{ config, pkgs, lib,... }:
let
  go = pkgs.go;
  golint = pkgs.golint.override {
    buildGoModule = pkgs.buildGoModule.override { go = pkgs.go; };
  };
  betteralign = pkgs.callPackage ./pkgs/betteralign { buildGoModule = pkgs.buildGoModule.override { go = pkgs.go; }; };
  gopium = pkgs.callPackage ./pkgs/gopium { buildGoModule = pkgs.buildGoModule.override { go = pkgs.go; }; };
in
{


  nixpkgs.config.allowUnfree= true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kiessk";
  home.homeDirectory = "/Users/kiessk";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  #required so installed fonts are found
  fonts={
    fontconfig.enable = true;
  };
  home.packages = with pkgs; [
    #fonts
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.symbols-only
    nerd-fonts.space-mono

    #comms
    slack

    #terminal tools
    fzf
    ripgrep
    wget
    bat
    direnv
    gnumake

    xournalpp

    #go dev tools
    go
    golint
    ginkgo
    betteralign
    gopium
    gopls


  ];
  programs.starship =
    let
      getPreset = name: (with builtins; removeAttrs (fromTOML (readFile "${pkgs.starship}/share/starship/presets/${name}.toml")) ["\"$schema\""]);
    in {
    enable = true;
    settings =
      lib.recursiveUpdate
      (lib.mergeAttrsList [
        (getPreset "nerd-font-symbols")
        (getPreset "gruvbox-rainbow")
      ])
    {

    };
  };
  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./bashrc + ''
      export PATH=~/.nix-profile/bin:$PATH
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '' ;
    shellAliases = {
      cat = "bat";
      ll = "ls -la";
    };

  };
  programs.git = {
    enable = true;
    extraConfig= {
      user = {
        name  = "nouseforaname";
        email = "34882943+nouseforaname@users.noreply.github.com";
        signingkey = "167CB2D0B694AD60";
      };
      pull = { rebase = true; };
      init = { defaultBranch = "main"; };
      push = { autoSetupRemote = true; };
      commit= {
        verbose = true;
        gpgsign = true;
      };
    };
  };

  programs.alacritty = {
     enable = true;
     settings = {
       window = {
         opacity = 0.9;
         blur = false;
       };
       font = {
         normal = {
           family = "IosevkaTerm Nerd Font";
	   style = "Regular";
         };
       };
       selection = {
         save_to_clipboard = true;
       };
       terminal = {
         shell = {
           program = "${pkgs.bash}/bin/bash";
         };
       };
     };
  };
  programs.gpg = {
    enable = true;
    settings = {
      personal-cipher-preferences="AES256 AES192 AES";
      personal-digest-preferences="SHA512 SHA384 SHA256";
      personal-compress-preferences="ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list="SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo="SHA512";
      s2k-digest-algo="SHA512";
      s2k-cipher-algo="AES256";
      charset="utf-8";
      no-comments=true;
      no-emit-version=true;
      no-greeting=true;
      keyid-format="0xlong";
      list-options="show-uid-validity";
      verify-options="show-uid-validity";
      with-fingerprint=true;
      require-cross-certification=true;
      require-secmem=true;
      no-symkey-cache=true;
      armor=true;
      use-agent=true;
      throw-keyids=true;
     };
     scdaemonSettings = {
       disable-ccid = true;
       reader-port = "Yubico YubiKey OTP+FIDO+CCID";
     };
     package = pkgs.gnupg;
   };
   services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    enableScDaemon = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    extraConfig = ''
      pinentry-program /Users/kiessk/.nix-profile/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      default-cache-ttl 60
      max-cache-ttl 120
      enable-ssh-support
      pinentry-program /Users/kiessk/.nix-profile/bin/pinentry-mac
    '';
  };
  programs.tmux = {
    package = pkgs.tmux;
    enable = true;
    shell = "${pkgs.bash}/bin/bash";
    terminal = "xterm-256color";
    keyMode = "vi";
    plugins = [ pkgs.tmuxPlugins.nord ];
    baseIndex = 1;
    extraConfig = ''
      set -g mouse off
      set-window-option -g xterm-keys on
      set -g pane-active-border-style bg=default,fg=red
    '';
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraConfig = builtins.readFile ./vimrc;
    extraPackages = with pkgs; [
      #LSPs implementation
      gopls
      rust-analyzer
      nil
      nixfmt

      #linters
      golint
      statix #nix-linter
      shellcheck
    ];
    plugins = with pkgs.vimPlugins; [
      # git
      git-blame-nvim

      # fonts
      nvim-web-devicons

      # navigation // search
      nvim-tree-lua
      fzf-vim

      # vim nix file highlighting & support
      vim-nix

      # markdown
      markdown-preview-nvim

      # snippets
      luasnip

      # config helper
      nvim-lspconfig

      # auto shell check
      vim-shellcheck

      #completion plugin
      nvim-cmp

      #completion sources
      cmp_luasnip
      cmp-nvim-lsp
    ];

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
