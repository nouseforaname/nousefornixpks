{ pkgs, ... }:
{
  hardware.gpgSmartcards.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
  programs.ssh.startAgent = false;

  services.pcscd = {
    enable = true;
    readerConfigs = [
      ''
        polkit.addRule(function(action, subject) {
                if (action.id == "org.debian.pcsc-lite.access_card" &&
                        subject.isInGroup("wheel")) {
                        return polkit.Result.YES;
                }
        });
        polkit.addRule(function(action, subject) {
                if (action.id == "org.debian.pcsc-lite.access_pcsc" &&
                        subject.isInGroup("wheel")) {
                        return polkit.Result.YES;
                }
        });
      ''
    ];
  };
  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
      settings = {
        ttyname = "$GPG_TTY";
        default-cache-ttl = 60;
        max-cache-ttl = 120;
      };
    };
    package = pkgs.gnupg;

  };
}
