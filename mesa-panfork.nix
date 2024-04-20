{ pkgs, inputs, ... }:
let
  mesa = pkgs.callPackage ./mesa {
    galliumDrivers = [ "panfrost" ];
    vulkanDrivers = [ "panfrost" ];
    OpenGL = null;
    Xplugin = null;
    enableGalliumNine = false;
    enableOSMesa = false;
    enableVaapi = false;
    enableVdpau = false;
    enableXa = false;
  };
  mesa-panthor = mesa.overrideAttrs (_: {
    src = inputs.mesa-panthor;
  });
in
{
  nixpkgs.overlays = [
    (self: super: { mesa  = mesa-panthor; })
  ];
  hardware.opengl = {
    enable = true;
    package = mesa-panthor.drivers;
  };
}

