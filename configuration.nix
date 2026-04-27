{ config, lib, modulesPath, ... }:
let
  pkgs = import <nixos-25.11> {
    config = {
      allowUnfree = true;
      rocmSupport = true;
    };
  };
  unstable = import <unstable> {
    config = {
      allowUnfree = true;
      rocmSupport = true;
    };
  };
in
{
  networking.hostName = "mobile_horse";
  imports = [
    (import ./hardware-configuration.nix { inherit config lib modulesPath; pkgs = unstable; })

    (import ./vim.nix { pkgs = unstable; })
    ./nix-settings.nix
    ./git.nix
    (import ./tmux.nix { pkgs = unstable; })
    (import ./nixos-home-manager.nix { pkgs = unstable; })
    (import ./tools.nix { inherit lib config; pkgs = unstable; })
    (import ./starship.nix { pkgs = unstable; })
    (import ./nouseforaname.nix { inherit pkgs; })
    (import ./yubikey.nix { pkgs = unstable; })
    (import ./ollama.nix {
      inherit config;
      inherit pkgs;
      #pkgs = unstable;
    })
    (import ./misc-settings.nix {
      pkgs = unstable;
    })
  ];


  services = {
    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
  };
  system.stateVersion = "23.11"; # Did you read the comment?
}
