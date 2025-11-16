{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/25.05";

  inputs.libs-cmake.url = "github:nnctroboticsclub/libs-cmake";
  inputs.libs-cmake.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      self,
      nixpkgs,
      libs-cmake,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      libs-cmake_pkgs = libs-cmake.packages.${system};

      mbed-os_pkgs = pkgs.callPackage ./mbed-os/default.nix {
        url = "https://github.com/mbed-ce/mbed-os.git";
        ref = "master";
        rev = "4ba00162ba2d73c64583018983391e1dfeaee83d";
      };

      mbed-ce-python = pkgs.python311.pkgs.callPackage ./mbed-ce-python-env/default.nix {
        inherit (mbed-os_pkgs) mbed-os-src;
        withPackages = pkgs.python311.withPackages;
      };
    in
    rec {
      lib.static-mbed-os = pkgs.callPackage ./static-mbed-os/default.nix {
        inherit mbed-ce-python;
        inherit (self.packages.${system}) static-mbed-os-core;

        inherit (mbed-os_pkgs) mbed-os;

        inherit (libs-cmake_pkgs) libs-cmake;
        inherit (libs-cmake_pkgs) gcc-arm-toolchain;
      };

      packages.${system} = {
        static-mbed-os-core = pkgs.callPackage ./pack-core/default.nix { };

        static-mbed-os-f446re = lib.static-mbed-os {
          pname = "static-mbed-os-f446re";
          mbedTarget = "NUCLEO_F446RE";
        };

        static-mbed-os-f303k8 = lib.static-mbed-os {
          pname = "static-mbed-os-f303k8";
          mbedTarget = "NUCLEO_F303K8";
        };
      };
    };
}
