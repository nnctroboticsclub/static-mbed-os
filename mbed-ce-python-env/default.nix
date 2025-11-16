{
  callPackage,
  withPackages,

  mbed-os-src,
}:
let
  lief_0_14_1 = callPackage ./lief_0_14_1.nix { };
  packaging_21_3 = callPackage ./packaging_21_3.nix { };
  click_8_0_4 = callPackage ./click_8_0_4.nix { };
  cryptography_36_0_1 = callPackage ./cryptography_36_0_1.nix { };
  setuptools_69_5_1 = callPackage ./setuptools_69_5_1.nix { };
  prettytable_3_12_0 = callPackage ./prettytable_3_12_0.nix {
    inherit setuptools_69_5_1;
  };

  cysecuretools = callPackage ./cysecuretools_6_0_0.nix {
    inherit cryptography_36_0_1;
    inherit click_8_0_4;
    inherit packaging_21_3;
    inherit lief_0_14_1;
  };

  mbed_tools = callPackage ./mbed_tools.nix {
    inherit setuptools_69_5_1;
    inherit prettytable_3_12_0;
    inherit mbed-os-src;
    inherit cryptography_36_0_1;
    inherit click_8_0_4;
  };
in
withPackages (ps: [
  mbed_tools
  cysecuretools
  cryptography_36_0_1
  # click_8_0_4
])
