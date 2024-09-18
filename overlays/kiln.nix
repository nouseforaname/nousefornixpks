self: super: 

let
  kiln = versionArg: sha256Arg: vendorHashArg: branchArg: (
  super.buildGoModule rec {

    pname = "kiln";
    version = versionArg;

    src = super.fetchFromGitHub {
      owner = "pivotal-cf";
      repo = "kiln";
      rev = branchArg;
      sha256 = sha256Arg;# super.lib.fakeHash; #sha256Arg;
      nativeBuildInputs = [ super.pkgs.go ];
      postFetch = ''
      # pushd $out
      #   go mod tidy
      #   go mod vendor 
      # popd
      '' ;
    };

    vendorHash = vendorHashArg;
#"sha256-hoF4uyB9N6msscFMy8EH7NCaH7D6ZpEqGmcbspph9J4="; ;
    proxyVendor = false;

    doCheck = false;

    ldflags = [ "-X main.Version=${versionArg}" ];

    preBuild = ''
      
    '';
    subPackages = [ "main.go" ];
    postBuild = ''
       cd "$GOPATH/bin"
       mv main kiln
    '';

    meta = with super.lib; {
      description = "Building tiles";
      homepage = "https://github.com/pivotal-cf/kiln";
      license = licenses.asl20;
      maintainers = with maintainers; [ kkiess ];
    };
  });
in {
  kiln_branch = kiln "0.94.0" "sha256-KqgrP66VKY80XnLhXqKKn2JG1bWZQw4XlQKWfXllKvg=" "sha256-hoF4uyB9N6msscFMy8EH7NCaH7D6ZpEqGmcbspph9J4=" "main";
}
