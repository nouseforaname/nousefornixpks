{
  pkgs,
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
    hash = "sha256-WJWy8vgMiVMCv3tiRTbDFVStDCx88DMDY4bUCttOzAs="; 
  };
  modRoot = ".";
  date = lib.readFile "${pkgs.runCommand "timestamp" { env.when = builtins.currentTime; } "echo -n `date -u '+%Y-%m-%dT%H:%M:%SZ'` > $out"}";

  vendorHash = "sha256-mX8sGHY/kutZip/KMC4cloc4Ql9Lv0NuVEXJYiXaJ/o="; 

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
