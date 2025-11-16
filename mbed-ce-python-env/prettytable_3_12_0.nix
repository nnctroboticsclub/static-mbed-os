{
  # Python
  buildPythonPackage,
  wcwidth,
  hatchling,
  hatch-vcs,

  # Modules
  setuptools_69_5_1,
}:
buildPythonPackage {
  pname = "prettytable_3_12_0";
  version = "3.12.0";

  src = fetchGit {
    url = "https://github.com/prettytable/prettytable";
    ref = "v3.12.0";
    rev = "ca90b055f20a6e8a06dcc46c2e3afe8ff1e8d0f1";
  };
  pyproject = true;
  propagatedBuildInputs = [
    setuptools_69_5_1
    wcwidth
  ];
  build-system = [
    hatchling
    hatch-vcs
  ];
}
