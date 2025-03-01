{...}:
let
  unstable = import ( <unstable> ) {};
in
{
    services.ollama = {
      package = unstable.ollama;
      enable = true;
      acceleration = "rocm";
    };
    services.open-webui = {
      enable = true;
      package = unstable.open-webui;
    };
}
