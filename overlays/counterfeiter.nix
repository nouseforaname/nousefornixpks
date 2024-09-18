self: super: 

let
  counterfeiter = versionArg: sha256Arg: vendorHashArg: branchArg: (
  super.buildGoModule rec {

    pname = "counterfeiter";
    version = versionArg;

    src = super.fetchFromGitHub {
      owner = "maxbrunsfeld";
      repo = "counterfeiter";
      rev = branchArg;
      sha256 = sha256Arg; #super.lib.fakeHash;# super.lib.fakeHash; #sha256Arg;
    };

    vendorHash = vendorHashArg; # super.lib.fakeHash;
    proxyVendor = false;
    doCheck = false;

    preBuild = ''
    '';
    subPackages = [ "main.go" ];
    postBuild = ''
       cd "$GOPATH/bin"
       mv main counterfeiter
    '';

    meta = with super.lib; {
      description = "Building tiles";
      homepage = "https://github.com/pivotal-cf/kiln";
      license = licenses.asl20;
      maintainers = with maintainers; [ kkiess ];
    };
  });
in {
  counterfeiter = counterfeiter "6.8.1" "sha256-rpV+WMXh8bNgKsbT8+pUyt9ZV2N8DUd3w/1uncnLP2A=" "sha256-92F1VZuRFs6LvaAABC/yLPxwlsu5z7cEclw2w24mYWk=" "v6.8.1";
}
