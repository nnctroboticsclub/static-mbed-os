{
  # Python
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage {
  pname = "packaging_21_3";
  version = "21.3";
  format = "wheel";

  src = fetchPypi {
    pname = "packaging";
    version = "21.3";
    format = "wheel";
    dist = "py3";
    python = "py3";
    abi = "none";
    platform = "any";

    sha256 = "sha256-7xA+BfUZzceDriTqTi4PUIqcmbLUlpZS7tai4epb1SI=";
  };
}
