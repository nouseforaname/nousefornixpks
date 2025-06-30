{ buildGoModule, fetchFromGitHub, stdenv, lib, writeText }:

buildGoModule rec {
  pname = "bosh";
  version = "7.9.7";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "bosh-cli";
    rev = "v${version}";
    sha256 = "sha256-Y3wk05IeWoH5YCrA+CJEtqvwCUxAvYdoYD+qDwTJo5Q=";
  };

  vendorHash = null;

  doCheck = false;

  ldflags=[ "-X 'github.com/cloudfoundry/bosh-cli/v7/cmd.VersionLabel=nix-${version}' -X 'main.Version=v${version}'" ];

  postInstall = ''
    mv $out/bin/bosh{-cli,}
  '';

  meta = with lib; {
    description = "Command line utility for interacting with a BOSH director";
    homepage = "https://github.com/cloudfoundry/bosh-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ nouseforaname ];
  };
}
