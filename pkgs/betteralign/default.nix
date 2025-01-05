{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
}:
buildGoModule rec {
  inherit go;
  pname = "betteralign";
  version = "0.6.1";
  src = fetchFromGitHub {
    owner = "dkorunic";
    repo = "betteralign";
    rev = "v${version}";
    hash = "sha256-IKKi5Paxg/OS8A95wifhIJUIoih8wQH2xRMLuqTioaE=";
  };
  modRoot = ".";
  vendorHash = "sha256-EXbtaxWo6djGzQy4KdCy80YmXdYenu2YyRTa2chaHxc=";#lib.fakeHash; 
  #"sha256-EXbtaxWo6djGzQy4KdCy80YmXdYenu2YyRTa2chaHxc=";

  # https://github.com/golang/tools/blob/9ed98faa/gopls/main.go#L27-L30
  ldflags = [ "-X main.version=v${version}" ];

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "cmd/betteralign" ];

  meta = with lib; {
    description = "betteralign is a tool to check for optimized field alignment in structs";
    homepage = "https://github.com/dkorunic/betteralign";
    changelog = "https://github.com/dkorunic/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      nouseforaname
    ];
    mainProgram = "betteralign";
  };
}
