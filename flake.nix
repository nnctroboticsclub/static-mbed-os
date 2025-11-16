{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/a9858885e197f984d92d7fe64e9fff6b2e488d40";

  inputs.libs-cmake.url = "github:nnctroboticsclub/libs-cmake";
  inputs.libs-cmake.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      nixpkgs,
      libs-cmake,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
      libs-cmake_pkgs = libs-cmake.packages.${system};
      mbed-ce-python = import ./mbed-ce-python-env/default.nix {
        inherit pkgs libs-cmake_pkgs;
      };
      static-mbed-os-core = pkgs.callPackage ./pack-core/default.nix { };
      static-mbed-os =
        {
          pname,
          mbedTarget,
        }:
        pkgs.stdenv.mkDerivation {
          inherit pname;
          version = "0.1.0";

          src = ./.;

          cmakeFlags =
            let
              paths = [
                "${libs-cmake_pkgs.libs-cmake}/lib/cmake"
                "${libs-cmake_pkgs.mbed-os}/lib/cmake"
                "${libs-cmake_pkgs.gcc-arm-toolchain}/lib/cmake"
              ];
              arg_MOD_PATH = lib.concatStringsSep ";" paths;
            in
            [
              "-DCMAKE_MODULE_PATH=${arg_MOD_PATH}"
              "-DCMAKE_BUILD_TYPE=Develop"
              "-DMBED_TARGET=${mbedTarget}"
              "-DMBED_ENABLE_TESTING=OFF"
              "-DMBED_CREATE_PYTHON_VENV=OFF"
            ];

          nativeBuildInputs = [
            pkgs.cmake
            libs-cmake_pkgs.libs-cmake
            libs-cmake_pkgs.mbed-os
            mbed-ce-python
          ];

          buildInputs = [
            static-mbed-os-core
          ];
        };
    in
    {
      packages.${system} = rec {
        static-mbed-os-core = static-mbed-os-core;

        static-mbed-os-f446re = static-mbed-os {
          pname = "static-mbed-os-f446re";
          mbedTarget = "NUCLEO_F446RE";
        };

        static-mbed-os-f303k8 = static-mbed-os {
          pname = "static-mbed-os-f303k8";
          mbedTarget = "NUCLEO_F303K8";
        };
      };
    };
}
