{ pkgs, config, ... }: {
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
      gnome-terminal
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

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];

      displayManager.gdm.enable = if (config.networking.hostName == "mobile_horse") then true else false;
      desktopManager.gnome.enable = if (config.networking.hostName == "mobile_horse") then true else false;

      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.sddm.enable = if (config.networking.hostName == "local_horse") then true else false;
    desktopManager.plasma6.enable = if (config.networking.hostName == "local_horse") then true else false;

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
