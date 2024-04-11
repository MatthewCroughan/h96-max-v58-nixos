{
  flake = {
    nixosModules.udev-rules = { ... }: {
      services = {
        udev.extraRules = ''
          # ID 2207:350b Fuzhou Rockchip Electronics Company
          SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="2207", ATTRS{idProduct}=="350b", GROUP="dialout", MODE="0666"
        '';
      };
    };
  };
}
