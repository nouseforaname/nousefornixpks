{ config, lib, modulesPath, ... }:
let
  unstable = import <unstable> {
    config = {
      allowUnfree = true;
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
    (import ./tools.nix { pkgs = unstable; })
    (import ./starship.nix { pkgs = unstable; })
    (import ./nouseforaname.nix { pkgs = unstable; })
    (import ./yubikey.nix { pkgs = unstable; })
    (import ./ollama.nix { inherit unstable config; })
    (import ./misc-settings.nix { inherit config; pkgs = unstable; })
  ];

  services = {
    fprintd.enable = true;
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
