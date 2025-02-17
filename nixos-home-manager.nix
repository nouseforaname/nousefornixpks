{ ... }:
let
  version = "release-24.11";
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
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    programs = {
      alacritty = {
        enable = true;
        settings = {
          window = {
            opacity = 0.9;
            blur = false;
          };
          font = {
            normal.family = "Iosevka";
            normal.style = "ExtraThin";
            bold.family = "Iosevka";
            bold.style = "SemiBold";
          };
          selection = {
            save_to_clipboard = true;
          };
        };
      };
    };
  };
}
