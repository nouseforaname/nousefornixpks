{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    };
    chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        "nngceckbapebfimnlniiiahkandclblb"
      ];
      extraOpts =  {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [
          "de"
          "en-US"
        ];
      };
    };
  };
  users.users.nouseforaname = {
    isNormalUser = true;
    description = "nouseforaname";

    extraGroups = [ "docker" "dialout" "tty" "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs;[
      # WEB / COMMUNICATION
      brave  # programs.chromium above will write the config.
      spotify
      signal-desktop
      element-desktop
      telegram-desktop
      slack
      discord
      evolution
      # CAD / 3D PRINTING
      prusa-slicer
      freecad
      blender-hip
      inkscape
    ];
  };
}
