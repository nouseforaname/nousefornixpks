# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable") {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./git/git.nix
      ./git/vim.nix
      ./git/tmux.nix
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  #android dev
  programs.adb.enable = true;
  services= {
    ollama = {
      enable = true;
      acceleration = "rocm";
      package = unstable.ollama;
      environmentVariables = {
        HSA_OVERRIDE_GFX_VERSION="11.0.2";
        OLLAMA_LLM_LIBRARY="rocm_v60000";
      };
    };
    udev.packages = [
      pkgs.android-udev-rules
      pkgs.qmk-udev-rules
    ];

    # Enable the X11 windowing system.
    xserver={
      enable = true;
      excludePackages = [ pkgs.xterm ];
      videoDrivers = [ "modesetting" ];

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

    # Keybase
    keybase.enable = true;
    kbfs = {
      enable = true;
      #enableRedirector = true;
    };
  };

  # override generated systemd unit. it sets PrivateTmp = true and that breaks kbfs mounts according to: https://github.com/nix-community/home-manager/issues/4722 not sure why this isn't in upstream nixpkgs
  systemd.user.services.kbfs.serviceConfig.PrivateTmp = pkgs.lib.mkForce false;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment = {
    enableAllTerminfo = true;
    systemPackages = with pkgs; [
      fzf
      bat
      unzip
      usbutils
      alacritty
      ripgrep
      fprintd
      dejavu_fonts
      iosevka
      fuse #if not explicitly installed it seems that the setuid bit from the binary is missing and kbfs fails mounting with permission issues
    ];
    interactiveShellInit = ''
      . ${config.users.users.nouseforaname.home}/workspace/nousefornixpks/bashrc
    '';
  };

  users.users.nouseforaname = {
    isNormalUser = true;
    description = "nouseforaname";
    extraGroups = [ "dialout" "tty" "networkmanager" "wheel" "adbusers" ];

    packages = with pkgs; [
      thunderbird
      prusa-slicer
      freecad
      element-desktop
      brave
      signal-desktop
      go
      xournalpp
      vlc
      blender-hip
      slack
      inkscape
      golint
      gopls
      android-studio
      spotify
    ];
  };

  programs = {
    hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
    };
    #direnv.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    steam =  {
      enable = true;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    };
  };
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    # rocmSupport = true;
  };
  system.stateVersion = "23.11"; # Did you read the comment?
}
