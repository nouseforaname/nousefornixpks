{ pkgs, ... }: {
  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
    efi.canTouchEfiVariables = true;
  };
  # Enable networking
  networking.networkmanager.enable = true;

  environment = {
    enableAllTerminfo = true;
    systemPackages = with pkgs; [
      unzip
      usbutils
      fprintd
      libfprint
    ];
    gnome.excludePackages = with pkgs; [
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
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ];
  };

  programs.nix-ld.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  security.rtkit.enable = true;
  services.displayManager.gdm.enable = true; #if (config.networking.hostName == "mobile_horse") then true else false;
  services.desktopManager.gnome.enable = true; #if (config.networking.hostName == "mobile_horse") then true else false;
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;
  };
}
