with (import <nixpkgs> {} );
stdenv.mkDerivation {
  name = "fly711";
  buildInputs = [ fly711 ];
}
