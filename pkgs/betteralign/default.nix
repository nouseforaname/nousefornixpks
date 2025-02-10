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
  date = "2025-01-05T20:04:01Z";

  vendorHash = "sha256-EXbtaxWo6djGzQy4KdCy80YmXdYenu2YyRTa2chaHxc=";

  ldflags = [ 
    #-extldflags '-static'  -s -w  -X main.GitDirty=$(cat .modified) 
    "-X main.GitTag=${version}"
    "-X main.GitCommit=${src.rev}"
    "-X main.BuildTime=${date}"
  ];

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
