self: super:

{
  credhub = super.callPackage ../pkgs/credhub { };
  bosh = super.callPackage ../pkgs/bosh { };
  bosh-bootloader = super.callPackage ../pkgs/bbl { };
  ruby-install = super.callPackage ../pkgs/ruby-install { };
} 
