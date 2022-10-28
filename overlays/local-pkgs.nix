self: super:
let 
  opkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/d1c3fea7ecbed758168787fe4e4a3157e52bc808.tar.gz";
in
{
  credhub = super.callPackage ../pkgs/credhub { };
  bosh = super.callPackage ../pkgs/bosh { };
  bosh-bootloader = super.callPackage ../pkgs/bbl { };
  #go_1_16 = super.callPackage opkgs.go_1_16 {};
  #go_1_16 = super.callPackage ( opkgs + "/pkgs/development/compilers/go/1.16.nix" ) self.lib.Foundation {  };
} 
