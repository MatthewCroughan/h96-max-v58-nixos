{ modulesPath, pkgs, lib, config, ... }:
let
  #uboot = pkgs.callPackage ./u-boot {};
  uboot = pkgs.ubootH96MaxV58;
in
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "arm-trusted-firmware-rk3588"
    "rkbin"
  ];

  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  sdImage = {
    firmwarePartitionOffset = 16;
    postBuildCommands = "dd if=${uboot}/u-boot-rockchip.bin of=$img seek=64 conv=notrunc";
    populateRootCommands = "${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot";
    compressImage = false;
  };

  boot.supportedFilesystems = lib.mkForce [ "vfat" ];
}
