with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    ruby_3_1
    rubyPackages.rake
    rubyPackages.rspec
    bundix
    rake
    git
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
