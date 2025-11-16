{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "static-mbed-os-core";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [
    pkgs.cmake
  ];
}
