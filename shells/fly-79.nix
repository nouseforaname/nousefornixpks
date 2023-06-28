with (import <nixpkgs> {} );
stdenv.mkDerivation {
  name = "fly79";
  buildInputs = [ fly79 ];
}
