with import <nixpkgs> {};
let
    opkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/7d7622909a38a46415dd146ec046fdc0f3309f44.tar.gz";
    }) {};
    bundler = pkgs.buildRubyGem rec {
    inherit ruby_2_7;
    ruby = ruby_2_7;
    name = "${gemName}-${version}";
    gemName = "bundler";
    version = "2.3.20";
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "sha256-gJJ3vHzrJo6XpHS1iwLb77jd9ZB39GGLcOJQSrgaBHw=";
      type = "gem";
    };
  };

in stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    ruby_2_7
    rubyPackages.rspec
    rubyPackages.rubocop
    bundler
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
