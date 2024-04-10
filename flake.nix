{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: rec {
    images = {
      h96-v58-max = (self.nixosConfigurations.h96-v58-max.extendModules {
        modules = [
          ./sd-image.nix
        ];
      }).config.system.build.sdImage;
    };
    packages.x86_64-linux.h96-v58-max-image = images.h96-v58-max;
    packages.aarch64-linux.h96-v58-max-image = images.h96-v58-max;
    nixosConfigurations = {
      h96-v58-max = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/profiles/minimal.nix"
          ./configuration.nix
          ./device-tree.nix
        ];
      };
    };
  };
}


