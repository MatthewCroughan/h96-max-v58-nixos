{ pkgs, lib, ... }:
{
  # This causes an overlay which causes a lot of rebuilding
  environment.noXlibs = lib.mkForce false;
  # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix" creates a
  # disk with this label on first boot. Therefore, we need to keep it. It is the
  # only information from the installer image that we need to keep persistent
  fileSystems."/" =
    { device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  hardware.firmware = [
    (pkgs.armbian-firmware.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "armbian";
        repo = "firmware";
        rev = "6c1532bccd4f99608d7f09a0f115214a7867fb0a";
        hash = "sha256-DlRKCLOGW15FNfuzB/Ua2r1peMn/xHBuhOEv+e3VvTk=";
      };
      compressFirmware = false;
      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/firmware
        cp -a * $out/lib/firmware/

#        ln -sf $out/lib/firmware/ap6275p/fw_bcm43752a2_pcie_ag.bin $out/lib/firmware/brcm/brcmfmac43752-pcie.bin
#        ln -sf $out/lib/firmware/ap6275p/fw_bcm43752a2_pcie_ag.bin $out/lib/firmware/brcm/brcmfmac43752-pcie.rockchip,rk3588.bin
#        ln -sf $out/lib/firmware/ap6275p/clm_bcm43752a2_pcie_ag.blob $out/lib/firmware/brcm/brcmfmac43752-pcie.clm_blob
#        ln -sf $out/lib/firmware/ap6275p/nvram_AP6275P.txt $out/lib/firmware/brcm/brcmfmac43752-pcie.txt
#        ln -sf $out/lib/firmware/ap6275p/config.txt $out/lib/firmware/brcm/brcmfmac43752-pcie-more-config.txt

        runHook postInstall
      '';
    })
  ];
  boot = {
#    kernelPackages = lib.mkForce pkgs.linuxPackages_testing;
    kernelPackages = lib.mkForce (pkgs.linuxKernel.packagesFor (pkgs.callPackage ./kernel.nix {}));
    loader = {
      generic-extlinux-compatible.enable = lib.mkDefault true;
      grub.enable = lib.mkDefault false;
    };
  };
  boot.kernelParams = pkgs.lib.mkForce [
    "console=ttyS2,1500000n8"
    "loglevel=7"
  ];
  boot.kernelPatches = (import ./kernelPatches.nix { fetchpatch2 = pkgs.fetchpatch2; });
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    git
    pciutils
    usbutils
    alsa-utils
    magic-wormhole
  ];
  nix.settings = {
    experimental-features = lib.mkDefault "nix-command flakes";
    trusted-users = [ "root" "@wheel" ];
  };
  services.openssh.enable = true;
  services.logind.extraConfig = ''
    RuntimeDirectorySize=50%
  '';
  users = {
    users = {
      root.password = "default";
      default = {
        password = "default";
        isNormalUser = true;
        extraGroups = [ "wheel" "dialout" "input" "video" "audio" ];
      };
    };
  };
  networking.wireless.enable = true;
  networking.wireless.networks.DoESLiverpool.pskRaw = "63e49f779a41eda7be1510a275a07e519d407af706d0f2d3cc3140b9aecd412f";
}
