# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "amdgpu" ];
  boot.extraModulePackages = [ ];


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/cbbb960f-0ebe-4b09-ab12-d84ba1218d57";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-5c393cfb-29cb-4920-94ae-c93d7097af8b".device = "/dev/disk/by-uuid/5c393cfb-29cb-4920-94ae-c93d7097af8b";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0E96-30E3";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware = {
    pulseaudio.enable = false;
    amdgpu = {
      opencl = {
        enable = true;
      };
      amdvlk.enable = true;
    };
    graphics.enable = true;
  };
  services.ollama.rocmOverrideGfx = "10.3.0";
}
