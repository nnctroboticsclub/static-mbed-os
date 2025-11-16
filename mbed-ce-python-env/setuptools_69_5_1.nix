{
  # Python
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage {
  pname = "setuptools_69_5_1";
  version = "69.5.1";
  format = "wheel";

  src = fetchPypi {
    pname = "setuptools";
    version = "69.5.1";
    format = "wheel";
    dist = "py3";
    python = "py3";
    abi = "none";
    platform = "any";

    sha256 = "sha256-xjasNhvEdYBQRkQnXJrYAsUEFcdSIhIlLAM70V8wHzI=";
  };
}
