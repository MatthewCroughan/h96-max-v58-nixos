{ pkgs, config, ... }:
{
  hardware = {
    deviceTree = {
      enable = true;
      kernelPackage = pkgs.runCommandCC "rk3588-H96-V58-dts" {
#        inherit (config.boot.kernelPackages.kernel) src;
        src = pkgs.runCommand "kernel-patched" {
          patches = (map (x: x.patch) config.boot.kernelPatches);
        } ''
          cp -r ${config.boot.kernelPackages.kernel.src} $out
          chmod -R +w $out
          cd $out
          patchPhase
        '';
        nativeBuildInputs = [ pkgs.dtc ];
      } ''
        unpackPhase
        cd "$sourceRoot"

        DTS=arch/arm64/boot/dts/rockchip/rk3588-H96-V58.dts
        cp ${./u-boot/rk3588-H96-V58.dts} "$DTS"
        mkdir -p "$out/dtbs/rockchip"
        $CC -E -nostdinc -Iinclude -undef -D__DTS__ -x assembler-with-cpp "$DTS" | \
          dtc -I dts -O dtb -@ -o $out/dtbs/rockchip/rk3588-H96-V58.dtb
      '';
    };
  };
}

