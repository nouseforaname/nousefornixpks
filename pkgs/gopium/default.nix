{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
}:
buildGoModule rec {
  inherit go;
  pname = "gopium";
  version = "1.8.0";
  src = fetchFromGitHub {
    owner = "1pkg";
    repo = "gopium";
    rev = "v${version}";
    hash = "sha256-p3THftnXtwll5rUVONt9MMG4Dt7EDMBFSeUi/lTUIrs="; 
  };
  modRoot = ".";
  vendorHash = "sha256-EiGX/sjTCigy3ThrHt7yEYbdyIAJeHJkiklJFVQhK54=";

  ldflags = [ "-X main.version=v${version}" ];

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Smart Go Structures Optimizer and Manager";
    homepage = "https://github.com/1pkg/gopium";
    changelog = "https://github.com/1pkg/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      nouseforaname
    ];
    mainProgram = "gopium";
  };
}
