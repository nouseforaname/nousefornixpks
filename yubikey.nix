{...}:
let
  pkgs = import ( <unstable> ) {};
in
{
  imports = [ "${pkgs.path}/nixos/modules/programs/tmux.nix" ];
  hardware.gpgSmartcards.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  services.pcscd = {
    enable = true;
    readerConfig = ''
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
    '';
  };
  programs.gnupg = { 
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
    package = pkgs.gnupg;
    
  };
}
