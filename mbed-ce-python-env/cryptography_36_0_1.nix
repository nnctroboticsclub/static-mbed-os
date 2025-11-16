{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  setuptools,
  setuptools-rust,
  cffi,
  openssl,
  pkg-config,
  cargo,
  rustc,
}:
buildPythonPackage rec {
  pname = "cryptography";
  version = "36.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = "cryptography";
    rev = version;
    hash = "sha256-3s8w9G4CcqM1v6kUiFmbirGD0qCO3OprXRgi7qh/W60=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = src + "/src/rust";
    hash = "sha256-fAVaNdSgHZAaaIUPoy87NaMMI/B9aZKvxIm/BSokSCs=";
  };

  cargoRoot = "src/rust";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    setuptools
    setuptools-rust
    pkg-config
  ];

  buildInputs = [ openssl ];

  propagatedBuildInputs = [ cffi ];

  doCheck = false;
  doInstallCheck = false;

  meta = with lib; {
    description = "Package which provides cryptographic recipes and primitives";
    homepage = "https://github.com/pyca/cryptography";
    license = with licenses; [
      asl20
      bsd3
    ];
  };
}
