{ buildUBoot, armTrustedFirmwareRK3588, rkbin, fetchFromGitHub }:
buildUBoot {
  version = "rk3588-H96-V58";
  src = fetchFromGitHub {
    owner = "u-boot";
    repo = "u-boot";
    # v2024.04 doesn't work due to regression, so this is a later master commit
    # after the regression was fixed
    # https://lore.kernel.org/u-boot/50dfa3d6-a1ca-4492-a3fc-8d8c56b40b43@kwiboo.se/
    rev = "af04f37a78c7e61597fb9ed6db2c8f8d7f8b0f92";
    hash = "sha256-l2y6pDo+WDXOURBNwvwEsNoKhpxfrLJVi7cJwALk1cw=";
  };
  defconfig = "H96_V58-rk3588_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
  ROCKCHIP_TPL = rkbin.TPL_RK3588;

  preConfigure = ''
    cp --no-preserve=mode ${./config} configs/H96_V58-rk3588_defconfig
    cp --no-preserve=mode ${./rk3588-H96-V58-u-boot.dtsi} arch/arm/dts/rk3588-H96-V58-u-boot.dtsi

    # u-boot mainline doesn't have gpu, hdmi, other nodes yet, so this one is a
    # copy of the full dts, with those missing nodes removed.
    cp --no-preserve=mode ${./rk3588-H96-V58-uboot-only-out-of-sync.dts} arch/arm/dts/rk3588-H96-V58.dts

    substituteInPlace arch/arm/dts/Makefile --replace rk3588-generic rk3588-H96-V58
  '';

  filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" ];
}

