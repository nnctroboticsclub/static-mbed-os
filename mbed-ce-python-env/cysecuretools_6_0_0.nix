{
  # Python
  buildPythonPackage,
  fetchPypi,
  intelhex,
  python-jose,
  jsonschema,
  cbor,
  pip,
  pyparsing,

  # Modules
  cryptography_36_0_1,
  click_8_0_4,
  packaging_21_3,
  lief_0_14_1,
}:
buildPythonPackage {
  pname = "cysecuretools_6_0_0";
  version = "6.0.0";
  format = "wheel";

  src = fetchPypi {
    pname = "cysecuretools";
    version = "6.0.0";
    format = "wheel";
    dist = "py3";
    python = "py3";
    abi = "none";
    platform = "any";

    sha256 = "04s3qypf83jilzs3p8781j0x04w5hrr9cbcc5izvdxx588qxcmqf";
  };

  # patches = [./cysecuretools_setup.py.patch];

  nativeBuildInputs = [
    cryptography_36_0_1
    click_8_0_4
  ];

  dependencies = [
    intelhex
    python-jose
    jsonschema
    cbor
    packaging_21_3
    lief_0_14_1
    pip
    pyparsing
  ];
}
