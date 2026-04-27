{pkgs, ... }:
let
  libdjinterop = pkgs.callPackage ./pkgs/libdjinterop {};
  mixxx-custom = pkgs.callPackage ./pkgs/mixxx { inherit libdjinterop; };
  go = pkgs.go;
  golint = pkgs.golint.override {
    buildGoModule = pkgs.buildGoModule.override { go = pkgs.go; };
  };
  betteralign = pkgs.callPackage ./pkgs/betteralign { buildGoModule = pkgs.buildGoModule.override { go = pkgs.go; }; };
  #gopium = pkgs.callPackage ./pkgs/gopium { buildGoModule = pkgs.buildGoModule.override { go = pkgs.go; }; };
in
{
  # wine printing requirement
  services.printing.cups-pdf.enable = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "-d";
  };
  programs = {
    nano.enable = false;
    dconf.enable = true;
    bash = {
      interactiveShellInit = builtins.readFile ./bashrc;
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

  };

    # printer driver
    services.printing.drivers = [
      pkgs.brlaser
      pkgs.brgenml1lpr
      pkgs.brgenml1cupswrapper
    ];
 #virtualisation.virtualbox.host.enable = true;
 #virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "nouseforaname" ];

  environment.systemPackages = with pkgs; [

    fzf
    ripgrep
    wget
    bat

    xournalpp
    vlc

    #raspi
    rpi-imager

    #GO DEV TOOLS
    go
    golint
    ginkgo
    betteralign
    #gopium
    gopls

    #java
    jdt-language-server

    mixxx-custom
    # support both 32-bit and 64-bit applications
    wineWow64Packages.stable
  ];
}
