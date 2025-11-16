{ pkgs, libs-cmake_pkgs }:
let
  prettytable_3_12_0 = pkgs.callPackage ./prettytable_3_12_0.nix { };
  lief_0_14_1 = pkgs.callPackage ./lief_0_14_1.nix { };
  packaging_21_3 = pkgs.callPackage ./packaging_21_3.nix { };
  click_8_0_4 = pkgs.callPackage ./click_8_0_4.nix { };
  cryptography_36_0_1 = pkgs.callPackage ./cryptography_36_0_1.nix { };

  cysecuretools = pkgs.callPackage ./cysecuretools_6_0_0.nix {
    inherit cryptography_36_0_1;
    inherit click_8_0_4;
    inherit packaging_21_3;
    inherit lief_0_14_1;
  };

  mbed_tools = pkgs.callPackage ./mbed_tools.nix {
    inherit prettytable_3_12_0;
    inherit libs-cmake_pkgs;
    inherit cryptography_36_0_1;
    inherit click_8_0_4;
  };
in
pkgs.python311.withPackages (ps: [
  mbed_tools
  cysecuretools
  cryptography_36_0_1
  # click_8_0_4
])
