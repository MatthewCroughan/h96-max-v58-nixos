{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mesa-panthor = {
      type = "gitlab";
      host = "gitlab.freedesktop.org";
      owner = "mesa";
      repo = "mesa";
      ref = "63d2aa4eb645e32ea3d5aea453a45aa6a3412e15";
      flake = false;
    };
  };
  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        flake-parts.flakeModules.easyOverlay
        ./flake-modules/udev-rules
        ./flake-modules/flash-scripts
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = {
          ubootH96MaxV58 = pkgs.callPackage ./u-boot {};
          rkboot = pkgs.callPackage ./rkboot {};
        };
        _module.args.pkgs = import inputs.nixpkgs {
          config.allowUnfree = true;
          config.allowUnsupportedSystem = true; # remove when https://github.com/NixOS/nixpkgs/pull/303370 is merged
          overlays = [
            inputs.self.overlays.default
          ];
          inherit system;
        };
        overlayAttrs = config.packages;
      };
      flake = let
        images = {
          h96-max-v58 = (inputs.self.nixosConfigurations.h96-max-v58.extendModules {
            modules = [
              ./sd-image.nix
            ];
          }).config.system.build.sdImage;
        };
      in {
        packages = {
          x86_64-linux.h96-max-v58-image = images.h96-max-v58;
          aarch64-linux.h96-max-v58-image = images.h96-max-v58;
        };
        nixosModules = {
          mesa-panfork = import ./mesa-panfork.nix;
        };
        nixosConfigurations = {
          h96-max-v58 = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/profiles/minimal.nix"
              inputs.self.nixosModules.mesa-panfork
              ./configuration.nix
              ./device-tree.nix
            ];
            specialArgs = { inherit inputs; };
          };
        };
      };
    };
}

