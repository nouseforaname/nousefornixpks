{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kiessk";
  home.homeDirectory = "/Users/kiessk";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

  ];
  programs.bash = {
    enable = true; 
    bashrcExtra = ''
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
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
  programs.alacritty.enable = true;
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
       reader-port = "Yubico Yubikey";
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
      pinentry-program /Users/lukasz/.nix-profile/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      default-cache-ttl 60
      max-cache-ttl 120
    '';
  };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kiessk/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
