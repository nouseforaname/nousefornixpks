{pkgs, ...}:
{
  programs.starship = {
    package = pkgs.starship;
    enable = true;
    presets = [
      "nerd-font-symbols"
      "gruvbox-rainbow"
    ];
  };
}
