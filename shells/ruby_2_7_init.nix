with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    ruby_2_7
    rubyPackages.rake
    rubyPackages.rspec
    bundix
    rake
    git
    sqlite
    libpcap
    postgresql
    libxml2
    libxslt
    pkg-config
    gnumake
    curlFull
  ];
}
