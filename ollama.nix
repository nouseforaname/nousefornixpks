{...}:
let
  unstable = import ( <unstable> ) {
    overlays = [
      (final: prev: {
        ollama-rocm-patched = prev.ollama-rocm.overrideAttrs { patches = [ ollama-amdgpu-gtt-patch ]; };
      })
    ];
  };
  ollama-amdgpu-gtt-patch = builtins.fetchurl {
    # See https://github.com/ollama/ollama/pull/6282/
    url = "https://patch-diff.githubusercontent.com/raw/ollama/ollama/pull/6282.patch";
  };
in
{
    services.ollama = {
      package = unstable.ollama-rocm-patched;
      enable = true;
      acceleration = "rocm";
    };
    services.open-webui = {
      enable = true;
      package = unstable.open-webui;
    };
}
