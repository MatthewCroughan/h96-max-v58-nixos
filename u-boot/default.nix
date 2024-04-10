{ buildUBoot, armTrustedFirmwareRK3588, rkbin, fetchpatch2, fetchFromGitHub, fetchFromGitLab }:
buildUBoot {
  version = "hacked";
#  extraPatches = [
#    (fetchpatch2 {
#      url = "https://raw.githubusercontent.com/HeyMeco/build/6012de75b46367741eba7a993dbbdad7c547a729/patch/u-boot/legacy/u-boot-radxa-rk3588/0003-add-defconfig-and-dtb-for-H96_V58.patch";
#      hash = "sha256-0y70+H9Jz7CtFABQceuEyZSbOdBE0XVp43fc/ViX0pk=";
#    })
#  ];
#  src = ./u-boot-2024.04-rc5;
  #src = fetchFromGitLab {
  #  domain = "gitlab.collabora.com";
  #  owner = "hardware-enablement/rockchip-3588";
  #  repo = "u-boot";
  #  rev = "889c316b59e2d715063f65931d7f2040e154fc4a";
  #  hash = "sha256-EgZ8HhXXlob00tEE9TcI0NOHQPFBNKXJaduJBAh4L3Q=";
  #};
  src = fetchFromGitHub {
    owner = "Kwiboo";
    repo = "u-boot-rockchip";
    rev = "rk3xxx-2024.04";
    hash = "sha256-daaWVIhkWkX64rMsE/uf19T13mZpmpSA8Vkehplc9Ig=";
  };
  defconfig = "H96_V58-rk3588_defconfig";
  #defconfig = "evb-rk3588_defconfig";
  #defconfig = "generic-rk3588_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
  ROCKCHIP_TPL = rkbin.TPL_RK3588;

  preConfigure = ''
    cp --no-preserve=mode ${./config} configs/H96_V58-rk3588_defconfig
    cp --no-preserve=mode ${./rk3588-H96-V58.dts} arch/arm/dts/rk3588-H96-V58.dts
  '';

  filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" ];
  postInstall = ''
    ls -lah
    ls -lah
    find -name '*generic*dtb'
  '';
}

