{ pkgs, config, ... }:
#let
 #ollama-amdgpu-gtt-patch = builtins.fetchurl {
 #  # See https://github.com/ollama/ollama/pull/6282/
 #  url = "https://patch-diff.githubusercontent.com/raw/ollama/ollama/pull/6282.patch";
 #};
 #ollama-rocm-patched = pkgs.ollama-rocm.overrideAttrs { patches = [ ollama-amdgpu-gtt-patch ]; };
#in
{
  services.ollama = {
    package = pkgs.ollama-rocm.overrideAttrs { rocmSupport = true; };
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx =
      if (config.networking.hostName == "mobile_horse") then
        "11.0.2"
      else
        "10.3.0";
  };
  services.open-webui = {
    enable = true;
    # nixos-unstable has torch marked as broken for rocm.
    package = pkgs.open-webui;
  };
}
