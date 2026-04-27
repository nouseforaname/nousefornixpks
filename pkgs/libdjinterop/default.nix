{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  boost,
  cmake,
  ninja,
  pkg-config,
  sqlite,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "libdjinterop";

  version = "a3daec8642a985c5fe35a99c5f7967077d69f544"; #0.27.1";

  src = fetchFromGitHub {
    owner = "xsco";
    repo = "libdjinterop";
    rev = finalAttrs.version;
    hash = "sha256-Uiz2VZef0+H9NfPgOPT1XVBKCiTXC/n8VKVveXEy40c=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    boost
    sqlite
    zlib
  ];

  meta = {
    homepage = "https://github.com/xsco/libdjinterop";
    description = "C++ library for access to DJ record libraries";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.unix;
  };
})
