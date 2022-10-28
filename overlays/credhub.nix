self: super:

let
   credhub = versionArg: sha256Arg: (
    super.buildGoModule rec {
      pname = "credhub-cli";
      version = versionArg;

      src = super.fetchFromGitHub {
        owner = "cloudfoundry-incubator";
        repo = "credhub-cli";
        rev = "2.9.6";
        sha256 = sha256Arg;
      };

      vendorHash = null;

      doCheck = false;
      ldflags = [
        "-X code.cloudfoundry.org/credhub-cli/version.Version=${versionArg}-nix"
      ];
      
      subPackages = [ "main.go" ];

      postBuild = ''
         cd "$GOPATH/bin"
         mv main credhub
      ''; 

      meta = with super.lib; {
        #description = "CredHub CLI provides a command line interface to interact with CredHub servers";
        homepage = "https://github.com/cloudfoundry-incubator/credhub-cli";
        license = licenses.mit;
        maintainers = with maintainers; [ rkoster ];
      };
    });

in {
  credhub_latest = credhub "2.9.6" "08q5dscgsvsmp5p0avxssnkl1wncw1iks0dis2m70mxhqaackcl3";
  credhub_2_9_6 = credhub "2.9.6" "08q5dscgsvsmp5p0avxssnkl1wncw1iks0dis2m70mxhqaackcl3";
}
