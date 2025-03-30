# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./git.nix
    ./vim.nix
    ./nix-settings.nix
    ./starship.nix
    ./tmux.nix
    ./yubikey.nix
    ./tools.nix
    ./nixos-home-manager.nix
    ./nouseforaname.nix
    ./ollama.nix
    "${unstable.path}/nixos/modules/services/misc/ollama.nix"
  ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 3;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  #android dev
  programs.adb.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  #these are overriden in imports
  disabledModules = [ "services/misc/ollama.nix" "programs/tmux.nix" ];

  services= {
    udev.packages = [
      pkgs.android-udev-rules
    ];

    # Enable the X11 windowing system.
    xserver={
      enable = true;
      excludePackages = [ pkgs.xterm ];
      videoDrivers = [ "amdgpu" ];

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };

    };
    # Enable CUPS to print documents.
    printing.enable = true;
    fprintd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

  };

  # override generated systemd unit. it sets PrivateTmp = true and that breaks kbfs mounts according to: https://github.com/nix-community/home-manager/issues/4722 not sure why this isn't in upstream nixpkgs
  systemd.user.services.kbfs.serviceConfig.PrivateTmp = pkgs.lib.mkForce false;
  # Enable sound with pipewire.
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment = {
    enableAllTerminfo = true;
    systemPackages = with pkgs; [
      unzip
      usbutils
      fprintd
      fuse #if not explicitly installed it seems that the setuid bit from the binary is missing and kbfs fails mounting with permission issues
    ];
    gnome.excludePackages = (with pkgs; [
      atomix # puzzle game
      cheese # webcam tool
      nano
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ]);
  };
  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "23.11"; # Did you read the comment?
}
