self: super:

let
  bosh = versionArg: sha256Arg: (
    super.buildGoModule rec {
      pname = "bosh";
      version = versionArg;

      src = super.fetchFromGitHub {
        owner = "cloudfoundry";
        repo = "bosh-cli";
        rev = "v${version}";
        sha256 = sha256Arg;
      };
      
      vendorSha256 = null;

      doCheck = false;

      preBuild = ''
        sed 's/\[DEV BUILD\]/'"${version}-nix"'/' cmd/version.go > cmd/version.tmp && mv cmd/version{.tmp,.go}
      '';

      subPackages = [ "main.go" ];

      postBuild = ''
         cd "$GOPATH/bin"

         mv main bosh
      ''; 

      meta = with super.lib; {
        #description = "BOSH CLI v2+";
        homepage = "https://github.com/cloudfoundry/bosh-cli";
        license = licenses.asl20;
        maintainers = with maintainers; [ rkoster ];
      };
    });
in {
  bosh-6-4-17 = bosh "6.4.17" "sha256-oVL7tBtdFJt6ktctSZiNZMd6g1LEWQ/Hra4rcGM6BnQ=";
  bosh-7-0-0 = bosh "7.0.0" "sha256-oVL7tBtdFJt6ktctSZiNZMd6g1LEWQ/Hra4rcGM6BnQ=";
  bosh-7-0-1 = bosh "7.0.1" "sha256-CNicDFmWq2tgw3LEw8nOlwewY3cpzwS9ea4fxbwVJc0=";
  bosh-7-2-3 = bosh "7.2.3" "sha256-CNicDFmWq2tgw3LEw8nOlwewY3cpzwS9ea4fxbwVJc0=";
  bosh-7-4-0 = bosh "7.4.0" "sha256-Hxak76S3+i5G81Xv4wdFvR/+vg5Eh86YjeqRzNUmfh4=";
}
