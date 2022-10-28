with (import <nixpkgs> {} );
stdenv.mkDerivation {
  name = "go_1_19";
  buildInputs = [ go_1_19 ginkgo ];
}
