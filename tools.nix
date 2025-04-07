{ pkgs, ... }:
let
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

  environment.systemPackages = with pkgs; [
    fzf
    ripgrep
    wget
    bat

    xournalpp
    vlc

    #GO DEV TOOLS
    go
    golint
    ginkgo
    betteralign
    gopium
    gopls
  ];
}
