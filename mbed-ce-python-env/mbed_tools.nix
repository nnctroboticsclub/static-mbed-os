{
  python311Packages,

  libs-cmake_pkgs,
  prettytable_3_12_0,
  cryptography_36_0_1,
  click_8_0_4,
}:
python311Packages.buildPythonPackage {
  name = "mbed-tools";
  src = "${libs-cmake_pkgs.mbed-os-src}/tools/";
  pyproject = true;
  build-system = [ python311Packages.hatchling ];

  nativeBuildInputs = [
    cryptography_36_0_1
    click_8_0_4
  ];

  dependencies = [
    python311Packages.appdirs
    python311Packages.cbor
    python311Packages.cmsis-pack-manager
    python311Packages.colorama
    python311Packages.fasteners
    python311Packages.gitpython
    python311Packages.humanize
    python311Packages.intelhex
    python311Packages.jinja2
    python311Packages.junit-xml
    python311Packages.lockfile
    prettytable_3_12_0
    python311Packages.psutil
    python311Packages.pyjson5
    python311Packages.pyserial
    python311Packages.python-dotenv
    python311Packages.pyudev
    python311Packages.requests
    python311Packages.setuptools
    python311Packages.tabulate
    python311Packages.tqdm
    python311Packages.typing-extensions
  ];

  importChecks = [ "mbed_tools.cli.cmsis_mcu_descr" ];
}
