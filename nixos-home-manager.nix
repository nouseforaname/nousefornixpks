{ pkgs, ... }:
let
  version = "master";
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager";
    ref = version;
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.nouseforaname = {
    home.stateVersion = "24.05"; 
    programs = {
      alacritty = {
        package = pkgs.alacritty;
        enable = true;
        settings = {
          window = {
            opacity = 0.9;
            blur = false;
          };
	  font = {
            normal = {
              family= "IosevkaTermNerdFont";
	    };	    
	  };
          selection = {
            save_to_clipboard = true;
          };
        };
      } ;
    };
  };
}
