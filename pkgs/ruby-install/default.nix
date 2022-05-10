{ stdenv, lib, fetchFromGitHub, runCommand, rubies ? null }:
let
  rubiesEnv = runCommand "chruby-env" { preferLocalBuild = true; } ''
    mkdir $out
    ${lib.concatStrings
      (lib.mapAttrsToList (name: path: "ln -s ${path} $out/${name}\n") rubies)}
  '';

in stdenv.mkDerivation rec {
  pname = "ruby-install";

  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "postmodern";
    repo = "ruby-install";
    rev = "7ac3be8";
    sha256 = "EJISa4q1tATAZ2E5CkBeOMskGG0DF2ewNnhGfGCKrkE=";

  };

  patches = lib.optionalString (rubies != null) [
  ];

  postPatch = lib.optionalString (rubies != null) ''
  '';

  installPhase = ''
    mkdir $out
    substituteInPlace $(pwd)/Makefile --replace '/usr/bin/env bash' $(type -p  bash)
    make install prefix=$(pwd) DESTDIR=$out
    mv $out/usr/local/* $out/
    rm -r $out/usr
    ls -la
  '';

  meta = with lib; {
    description = "Changes the current Ruby";
    homepage = "https://github.com/postmodern/ruby-install";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nouseforaname ];
  };
}
