inputs: {
  perSystem = { config, self', inputs', pkgs, system, ... }: let
    aarch64pkgs = import pkgs.path { system = "aarch64-linux"; overlays = [ inputs.self.overlays.default ]; config.allowUnfree = true; };
  in {
    packages.flash-spl = pkgs.writeShellScriptBin "flash-spl" ''
      set -x
      ${pkgs.lib.getExe pkgs.rkdeveloptool} db ${pkgs.rkboot}/bin/rk3588_spl_loader*.bin
    '';
    packages.flash-uboot = pkgs.writeShellScriptBin "flash-uboot" ''
      set -x
      ${pkgs.lib.getExe self'.packages.flash-spl}
      ${pkgs.lib.getExe pkgs.rkdeveloptool} wl 0x40 ${aarch64pkgs.ubootH96MaxV58}/u-boot-rockchip.bin
      ${pkgs.lib.getExe pkgs.rkdeveloptool} rd
    '';
    packages.flash-os = pkgs.writeShellScriptBin "flash-os" ''
      set -x
      ${pkgs.lib.getExe self'.packages.flash-spl}
      ${pkgs.lib.getExe pkgs.rkdeveloptool} wl 0 ${self'.packages.h96-max-v58-image}/sd-image/*.img
      ${pkgs.lib.getExe pkgs.rkdeveloptool} rd
    '';
  };
}

