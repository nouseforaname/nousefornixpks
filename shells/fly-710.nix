with (import <nixpkgs> {} );
stdenv.mkDerivation {
  name = "fly710";
  buildInputs = [ fly710 ];
}
