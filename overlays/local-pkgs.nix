self: super:

{
  bosh = super.callPackage ../pkgs/bosh { };
  ruby-install = super.callPackage ../pkgs/ruby-install { };
} 
