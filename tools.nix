{ ...}:
let
  pkgs = import ( <unstable> ) {
    config = {
      allowUnfree = true;
    };
};
  go = pkgs.go;
  gopls = pkgs.gopls.override {
    buildGoModule = pkgs.buildGoModule.override { go = pkgs.go; };
  };
  golint = pkgs.golint.override {
    buildGoModule = pkgs.buildGoModule.override { go = pkgs.go; };
  };
  betteralign = pkgs.callPackage ./pkgs/betteralign { buildGoModule = pkgs.buildGoModule.override { go = pkgs.go; };};
  gopium = pkgs.callPackage ./pkgs/gopium { buildGoModule = pkgs.buildGoModule.override { go = pkgs.go; };};
in
{

  programs = {
    nano.enable = false;
    dconf.enable = true;
    bash = {
      shellInit = builtins.readFile ./bashrc;
      shellAliases = {
        l = "ls -alh";
        ll = "ls -l";
        ls = "ls --color=tty";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    steam =  {
      enable = true;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    };
    chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        "nngceckbapebfimnlniiiahkandclblb"
      ];
      extraOpts =  {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [
          "de"
          "en-US"
        ];
      };
    };
  }; 
  environment.systemPackages = with pkgs; [
    fzf
    ripgrep
    wget
    bat

    # CAD / 3D PRINTING
    prusa-slicer
    freecad
    blender-hip
    inkscape

    # WEB
    brave  # programs.chromium above will write the config.
    spotify
    xournalpp
    vlc

    #GO DEV TOOLS
    go
    golint
    betteralign
    gopium
    gopls
    #android-studio

    #COMMUNICATION
    signal-desktop
    element-desktop
    telegram-desktop
    slack
    evolution
  ];
}
