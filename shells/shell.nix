with (import <nixpkgs> {} );
let
  env = bundlerEnv {
    name = "vsphere_cpi-bundler-env";
    ruby = ruby_3_1;
    inherit ruby_3_1;
    gemfile  = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset   = ./gemset.nix;
    gemdir   = ./.;
  };
in stdenv.mkDerivation {
  name = "vsphere_cpi";
  buildInputs = [ env env.wrappedRuby ];
}
