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
    version = "2.3.11";
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "sha256-deeQ3fNwcSiGSO/yeB2yoTniRq2gHW8WueprXoPX6Jk="; #2.3.11
      type = "gem";
    };
  };




in mkShell {
  name = "env";
  inherit bundler;
  buildInputs = [
    bundler
    ruby_3_1
    sqlite
    libpcap
    libyaml
    postgresql
    opkgs.mysql57
    libxml2
    libxslt
    pkg-config
    gnumake
    curlFull
    rubyPackages_3_1.solargraph
  ];
}
