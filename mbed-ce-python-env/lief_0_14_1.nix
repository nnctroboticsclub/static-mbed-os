{
  # Nixpkgs
  stdenv,
  autoPatchelfHook,

  # Python
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage {
  pname = "lief_0_14_1";
  version = "3.12.0";
  format = "wheel";

  src = fetchPypi {
    pname = "lief";
    version = "0.14.1";
    format = "wheel";
    dist = "cp311";
    python = "cp311";
    abi = "cp311";
    platform = "manylinux_2_28_x86_64.manylinux_2_27_x86_64";

    sha256 = "sha256-/Ugb/f7wTovk0gC8p3HQ2TlNkUbGzUA/nljIDEGWok4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];
}
