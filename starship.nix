{...}:
let
  unstable = import ( <unstable> ) {};
  stable = import ( <nixpkgs> ) {};
in
{
  fonts.packages = with unstable;[
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.symbols-only
    nerd-fonts.space-mono
  ];
  programs.starship = {
    package = unstable.starship;
    enable = true;
    presets = [
      "nerd-font-symbols"
      "gruvbox-rainbow"
    ];
  };
}
