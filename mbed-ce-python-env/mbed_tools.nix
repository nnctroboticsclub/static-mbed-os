{
  # Python
  buildPythonPackage,
  hatchling,
  appdirs,
  cbor,
  cmsis-pack-manager,
  colorama,
  fasteners,
  gitpython,
  humanize,
  intelhex,
  jinja2,
  junit-xml,
  lockfile,
  psutil,
  pyjson5,
  pyserial,
  python-dotenv,
  pyudev,
  requests,
  tabulate,
  tqdm,
  typing-extensions,

  # Mbed OS source
  mbed-os-src,

  # Modules
  setuptools_69_5_1,
  prettytable_3_12_0,
  cryptography_36_0_1,
  click_8_0_4,
}:
buildPythonPackage {
  name = "mbed-tools";
  src = "${mbed-os-src}/tools/";
  pyproject = true;
  build-system = [ hatchling ];

  nativeBuildInputs = [
    cryptography_36_0_1
    click_8_0_4
  ];

  dependencies = [
    appdirs
    cbor
    cmsis-pack-manager
    colorama
    fasteners
    gitpython
    humanize
    intelhex
    jinja2
    junit-xml
    lockfile
    prettytable_3_12_0
    psutil
    pyjson5
    pyserial
    python-dotenv
    pyudev
    requests
    setuptools_69_5_1
    tabulate
    tqdm
    typing-extensions
  ];

  importChecks = [ "mbed_tools.cli.cmsis_mcu_descr" ];
}
