{
  python311Packages,

  cryptography_36_0_1,
  click_8_0_4,
  packaging_21_3,
  lief_0_14_1,
}:
python311Packages.buildPythonPackage {
  pname = "cysecuretools";
  version = "6.0.0";
  format = "setuptools";

  src = fetchGit {
    url = "https://github.com/Infineon/cysecuretools";
    ref = "refs/tags/release-v6.0.0";
    rev = "00a8cc2d325f4ade9313b955b4adb33aec6fc092";
  };

  patches = [
    ./cysecuretools_setup.py.patch
  ];

  nativeBuildInputs = [
    cryptography_36_0_1
    click_8_0_4
  ];

  dependencies = [
    python311Packages.setuptools
    python311Packages.intelhex
    python311Packages.python-jose
    python311Packages.jsonschema
    python311Packages.cbor
    packaging_21_3
    lief_0_14_1
    python311Packages.pip
    python311Packages.pyparsing
  ];
}
