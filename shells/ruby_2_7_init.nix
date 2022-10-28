with import <nixpkgs> {};
let
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
    mysql57
    libxml2
    libxslt
    pkg-config
    gnumake
    curlFull
  ];
}
