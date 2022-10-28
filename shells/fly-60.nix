with (import <nixpkgs> {} );
stdenv.mkDerivation {
  name = "fly60";
  buildInputs = [ fly60 ];
}
