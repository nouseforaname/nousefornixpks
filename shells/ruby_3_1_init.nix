with import <nixpkgs> {};
let

  opkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/7d7622909a38a46415dd146ec046fdc0f3309f44.tar.gz";
  }) {};


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
    opkgs.mysql57
    libxml2
    libxslt
    pkg-config
    gnumake
    curlFull
  ];
}
