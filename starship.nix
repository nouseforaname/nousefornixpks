{pkgs, ...}:
{
  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.symbols-only
    nerd-fonts.space-mono
  ];
  programs.starship = {
    package = pkgs.starship;
    enable = true;
    presets = [
      "nerd-font-symbols"
      "gruvbox-rainbow"
    ];
  };
}
