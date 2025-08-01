{ version, sha256, vendorHash, buildGoModule, fetchFromGitHub, lib}:

buildGoModule {
  name = "bbr";
  version = version;
  vendorHash = vendorHash;

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "bosh-backup-and-restore";
    rev = "v${version}";
    sha256 = sha256;
  };


  doCheck = false;
  preCheck = false;
  subPackages = [ "cmd/bbr" ];

  ldflags=[ "-X 'main.Version=v${version}'" ];

  postInstall = '''';

  meta = with lib; {
    description = "Command line utility for interacting with a BOSH director";
    homepage = "https://github.com/cloudfoundry/bosh-backup-and-restore";
    license = licenses.asl20;
    maintainers = with maintainers; [ nouseforaname ];
  };
}
