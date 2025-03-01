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
}
