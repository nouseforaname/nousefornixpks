self: super:

{
  credhub = super.callPackage ../pkgs/credhub { };
  bosh = super.callPackage ../pkgs/bosh { };
  ruby-install = super.callPackage ../pkgs/ruby-install { };
# fly = super.callPackage ./fly60 {};
} 
