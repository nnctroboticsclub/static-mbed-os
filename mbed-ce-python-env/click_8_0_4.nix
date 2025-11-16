{
  python311Packages,
}:
python311Packages.buildPythonPackage {
  pname = "click_8_0_4";
  version = "8.0.4";
  format = "wheel";

  src = python311Packages.fetchPypi {
    pname = "click";
    version = "8.0.4";
    format = "wheel";
    dist = "py3";
    python = "py3";
    abi = "none";
    platform = "any";

    sha256 = "sha256-anpiVju/q/2jo48wI6HbSjWXjAq9dvbJYF7NZVTW2bE=";
  };
}
