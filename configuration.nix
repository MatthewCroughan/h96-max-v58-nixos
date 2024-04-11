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
  boot = {
#    kernelPackages = lib.mkForce (pkgs.linuxKernel.packagesFor (pkgs.callPackage ./kernel.nix {}));
    kernelPackages = lib.mkForce pkgs.linuxPackages_testing;
    loader = {
      generic-extlinux-compatible.enable = lib.mkDefault true;
      grub.enable = lib.mkDefault false;
    };
  };
  boot.kernelParams = pkgs.lib.mkForce [
    "console=ttyS2,1500000n8"
    "loglevel=7"
  ];
  hardware.opengl.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    git
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
}
