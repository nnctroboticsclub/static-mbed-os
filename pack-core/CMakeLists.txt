cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

set(CMAKE_INSTALL_MESSAGE LAZY)

project(static-mbed-os-core VERSION 1.0.1)

# ----- Target Installer
install(
  FILES
    FindStaticMbedOS.cmake
  DESTINATION share/cmake
)

#* CPack
set(CPACK_VERBATIM_VARIABLES YES)
set(CPACK_PACKAGE_NAME "StaticMbedOS-Core")
set(CPACK_PACKAGE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/dist")
set(CPACK_PACKAGE_CONTACT "syoch64@gmail.com")
set(CPACK_GENERATOR "DEB;TGZ")

# deb specific
set(CPACK_DEBIAN_PACKAGE_NAME "static-mbed-os-core")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "syoch")
set(CPACK_DEBIAN_PACKAGE_DESCRIPTION "StaticMbedOS Core")
set(CPACK_DEBIAN_PACKAGE_SECTION "libs")

include(InstallRequiredSystemLibraries)
include(CPack)
