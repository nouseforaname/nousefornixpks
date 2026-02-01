{ pkgs, ...}:
let
  version = "master";
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager";
    ref = version;
  };
  stylix = builtins.fetchGit {
    url = "https://github.com/nix-community/stylix";
    ref = version;
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
    (import stylix).nixosModules.stylix
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    opacity = {
      terminal = 0.9;
      applications = 0.9;
    };
    fonts = {
      serif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "IosevkaNerdFont";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "IosevkaNerdFont";
      };
      monospace = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaNerdFont";
      };
    };
    targets.qt = {
      enable = true;
      platform = pkgs.lib.mkForce "qtct";
    };
    cursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 20;
    };
  };

  home-manager= {
    users.nouseforaname = {
      home.stateVersion = "24.05";
      programs = {
        alacritty = {
          package = pkgs.alacritty;
          enable = true;
          settings = {
            window = {
              blur = false;
            };
            selection = {
              save_to_clipboard = true;
            };
          };
        };
      };
    };
  };
}
