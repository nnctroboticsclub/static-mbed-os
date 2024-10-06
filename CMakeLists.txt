cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
  /usr/arm-none-eabi/local/share/cmake
)
set(CMAKE_INSTALL_MESSAGE LAZY)
set(MBED_APP_JSON_PATH mbed_app.json)
set(MBED_TOOLCHAIN GCC_ARM)

include(MbedCE)
include(TargetDumper)

project(static-mbed-os)

# ----- Target

add_library(static-mbed-os-${MBED_TARGET} STATIC source/mbed-os.cpp)
target_link_libraries(static-mbed-os-${MBED_TARGET} PUBLIC mbed-os)
install(
  TARGETS static-mbed-os-${MBED_TARGET}
  ARCHIVE DESTINATION share/cmake/mbed-os@3297bae/
)

print_target_properties(mbed-os)

# ---- Install Headers
get_target_property(compile_options mbed-os INTERFACE_COMPILE_OPTIONS)
file(WRITE ${CMAKE_BINARY_DIR}/compile-options.txt "${compile_options}")

file(GENERATE
  OUTPUT ${CMAKE_BINARY_DIR}/includes.txt
  CONTENT "$<TARGET_PROPERTY:mbed-os,INTERFACE_INCLUDE_DIRECTORIES> $<TARGET_PROPERTY:mbed-core-flags,INTERFACE_INCLUDE_DIRECTORIES>"
)
file(GENERATE
  OUTPUT ${CMAKE_BINARY_DIR}/definitions.txt
  CONTENT "$<JOIN:$<TARGET_PROPERTY:mbed-os,INTERFACE_COMPILE_DEFINITIONS>,\n>"
)
file(GENERATE
  OUTPUT ${CMAKE_BINARY_DIR}/link-libraries.txt
  CONTENT "$<JOIN:$<TARGET_PROPERTY:mbed-os,INTERFACE_LINK_LIBRARIES>,\n>"
)
file(GENERATE
  OUTPUT ${CMAKE_BINARY_DIR}/link-options.txt
  CONTENT "$<JOIN:$<TARGET_PROPERTY:mbed-os,INTERFACE_LINK_OPTIONS>,\n>"
)
file(GENERATE
  OUTPUT ${CMAKE_BINARY_DIR}/mbed-located-at.txt
  CONTENT "${mbed-os_SOURCE_DIR}"
)

install(
  FILES
    ${CMAKE_BINARY_DIR}/compile-options.txt
    ${CMAKE_BINARY_DIR}/definitions.txt
    ${CMAKE_BINARY_DIR}/includes.txt
    ${CMAKE_BINARY_DIR}/link-libraries.txt
    ${CMAKE_BINARY_DIR}/link-options.txt
    ${CMAKE_BINARY_DIR}/mbed-located-at.txt
    ${CMAKE_BINARY_DIR}/mbed_config.cmake
  DESTINATION share/cmake/mbed-os@3297bae
)

install(
  FILES $<TARGET_PROPERTY:mbed-os,LINKER_SCRIPT_PATH>
  DESTINATION share/cmake/mbed-os@3297bae
  RENAME linker_script.ld
)

install(
  FILES $<FILTER:$<TARGET_OBJECTS:mbed-os>,INCLUDE,mbed_alloc_wrappers>
  DESTINATION share/cmake/mbed-os@3297bae
  RENAME mbed_alloc_wrappers.obj
)

install(
  FILES
    cmake/FindStaticMbedOS.cmake
    cmake/FindStaticMbedOSInternal.cmake
    cmake/UseStaticMbedOS.cmake
  DESTINATION share/cmake
)

