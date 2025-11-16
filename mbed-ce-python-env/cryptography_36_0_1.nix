{
  python311Packages,
  fetchPypi,
  rustPlatform,
}:
python311Packages.cryptography.overrideAttrs (old: rec {
  pname = "cryptography";
  version = "36.0.1";
  patches = [ ];
  postPatch = "";
  doCheck = false;
  doInstallCheck = false;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U+XB3D16lT3gVdd77y/2B87veiqsA1O11jCrZ/dCNjg=";
  };
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${old.cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-kozYXkqt1Wpqyo9GYCwN08J+zV92ZWFJY/f+rulxmeQ=";
  };
})
