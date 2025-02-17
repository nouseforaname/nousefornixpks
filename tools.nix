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
  users.users.nouseforaname = {
    isNormalUser = true;
    description = "nouseforaname";
    extraGroups = [ "docker" "dialout" "tty" "networkmanager" "wheel" "adbusers" ];

    packages = with pkgs; [
      # CAD / 3D PRINTING
      prusa-slicer
      freecad
      blender-hip
      inkscape

      # WEB
      brave
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
      thunderbird
    ];
  };
  programs = {
    nano.enable = false;
    dconf.enable = true;
    direnv.enable = true;
  }; 
  environment.systemPackages = with pkgs; [
    fzf
    ripgrep
    wget
    bat
  ];
}
