with (import <nixpkgs> {} );
stdenv.mkDerivation {
  name = "fly78";
  buildInputs = [ fly78 ];
}
