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
    rev = "${version}";
    hash = "sha256-3s8w9G4CcqM1v6kUiFmbirGD0qCO3OprXRgi7qh/W60=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-fAVaNdSgHZAaaIUPoy87NaMMI/B9aZKvxIm/BSokSCs=";
    sourceRoot = "${pname}-${version}/src/rust";
  };

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

  # Copy Cargo.lock from src/rust to root directory for cargoSetupHook
  postUnpack = ''
    if [ -f "source/src/rust/Cargo.lock" ]; then
      cp "source/src/rust/Cargo.lock" "source/Cargo.lock"
    fi
  '';

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
