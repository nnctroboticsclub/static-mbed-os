{
  cmake,

  static-mbed-os-f446re,
  buildCMakeProject,
}:
{
  test-smbed = import ./build-test {
    inherit cmake static-mbed-os-f446re buildCMakeProject;
  };
}
