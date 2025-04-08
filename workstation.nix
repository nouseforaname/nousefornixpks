{ config, lib, modulesPath, ... }:
let
  unstable = import <unstable> {
    config = {
      allowUnfree = true;
      # reenable once rocm 6.3 is available. will break open-webui because of torch rocm dependency broken
      # rocmSupport = true;
    };
  };
in
{
  networking.hostName = "local_horse";
  imports =
    [
      (import ./workstation-hardware.nix { inherit config lib modulesPath; pkgs = unstable; })

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

  system.stateVersion = "24.05"; # Did you read the comment?
}
