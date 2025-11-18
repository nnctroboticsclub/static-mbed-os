{
  cmake,

  static-mbed-os-f446re,
  buildCMakeProject,
}:
buildCMakeProject {
  pname = "static-mbed-os-test";
  version = "0.1.0";
  src = ./smbed;

  cmakeBuildInputs = [ static-mbed-os-f446re ];
  nativeBuildInputs = [ static-mbed-os-f446re ];
  buildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_TOOLCHAIN_FILE=StaticMbedOSToolchain-NUCLEO_F446RE"
  ];
  noInstall = true;

  # Enable verbose build for debugging
  ninjaFlags = [ "-v" ];
  makeFlags = [ "VERBOSE=1" ];
}
