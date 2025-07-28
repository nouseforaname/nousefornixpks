{ version, sha256, hash, buildGoModule, fetchFromGitHub, stdenv, lib, writeText }:

buildGoModule rec {
  pname = "carousel";
  name = "carousel";
  src = fetchFromGitHub {
    owner = "cloudfoundry-community";
    repo = "carousel";
    rev = "v${version}";
    sha256 = "${sha256}";
  };

  vendorHash = hash;
  proxyVendor = true;
  doCheck = false;
  preCheck = false;
  subPackages = ["."];
  ldflags=[
    "-X 'github.com/cloudfoundry-community/carousel/cmd.SemVerVersion=v${version}'"
  ];

  meta = with lib; {
    description = "Command line utility for interacting dealing with certificates used by a BOSH director";
    homepage = "https://github.com/cloudfoundry-community/carousel";
    license = licenses.asl20;
    maintainers = with maintainers; [ nouseforaname ];
  };
}
