{ pkgs, ... }:
let
  unstable = import <unstable> {
    config = {
      allowUnfree = true;
      rocmSupport = true;
    };
 };
in
{

  imports =
    [ # Include the results of the hardware scan.
      ./workstation-hardware.nix
      ./vim.nix
      ./nix-settings.nix
      ./git.nix
      ./tmux.nix
      ./nixos-home-manager.nix
      ./tools.nix
      ./starship.nix
      ./nouseforaname.nix
      ./yubikey.nix
      ./ollama.nix
      "${unstable.path}/nixos/modules/services/misc/ollama.nix"
    ];
  disabledModules = [ "services/misc/ollama.nix" "programs/tmux.nix" ];

  # Bootloader.
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    loader = {
      systemd-boot.enable = true;
      #efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.keybase = {
    enable = true;
  };
  systemd.user.services.keybase.serviceConfig.ExecPostStart = "${pkgs.keybase}/bin/keybase login";
  services.kbfs = {
    enable = true;
  };
  #kbfs wont mount when the systemd unit is set to PrivateTmp. No idea why.
  systemd.user.services.kbfs.serviceConfig.PrivateTmp = pkgs.lib.mkForce false;

  system.stateVersion = "24.05"; # Did you read the comment?
  
  virtualisation.docker.enable = true;

}
