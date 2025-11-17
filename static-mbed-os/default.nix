{
  lib,
  stdenv,
  cmake,

  libs-cmake,
  gcc-arm-toolchain,

  mbed-os,
  mbed-ce-python,
  static-mbed-os-core,
}:
{
  pname,
  mbedTarget,
}:
stdenv.mkDerivation {
  inherit pname;
  version = "0.1.0";

  src = ./.;

  cmakeFlags =
    let
      paths = [
        "${libs-cmake}/lib/cmake"
        "${mbed-os}/lib/cmake"
        "${gcc-arm-toolchain}/lib/cmake"
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

  cmakeBuildInputs = [
    gcc-arm-toolchain
    libs-cmake
    mbed-os
  ];

  nativeBuildInputs = [
    cmake
    libs-cmake
    mbed-os
    mbed-ce-python
  ];

  buildInputs = [
    static-mbed-os-core
  ];

  propagatedBuildInputs = [
    gcc-arm-toolchain
    libs-cmake
    mbed-os
  ];

  # Ensure that dependent packages can find the CMake modules
  postInstall = ''
    mkdir -p $out/nix-support
    echo "export CMAKE_MODULE_PATH=\''${CMAKE_MODULE_PATH:+\$CMAKE_MODULE_PATH:}$out/lib/cmake" >> $out/nix-support/setup-hook
  '';
}
