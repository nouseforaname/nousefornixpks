with import <nixpkgs> {};
let
  bundler = pkgs.buildRubyGem rec {
    inherit ruby_3_1;
    ruby = ruby_3_1;
    name = "${gemName}-${version}";
    gemName = "bundler";
    version = "2.3.5";
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "sha256-JVPL0Ti0ZrxWo8ckxcKGSN/44jQ7E6fGls+cKBjI1ik=";
      type = "gem";
    };
  };




in mkShell {
  name = "env";
  buildInputs = [
    bundler
    ruby_3_1
    bundix
    sqlite
    libpcap
    postgresql
    mysql57
    libxml2
    libxslt
    pkg-config
    gnumake
    curlFull
  ];
}
