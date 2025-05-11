cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
  /usr/arm-none-eabi/share/cmake
  /usr/arm-none-eabi/lib/cmake
)
set(CMAKE_INSTALL_MESSAGE LAZY)
set(MBED_APP_JSON_PATH mbed_app.json)
set(MBED_TOOLCHAIN GCC_ARM)

include(TargetDumper)
include(DependencyFinder)
include(MbedCE)
string(REPLACE " -Wl,--cref" "" CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT}")

project(static-mbed-os)

# ----- Target Installer
include(CMakePackageConfigHelpers)


# ----- Target Names
set(static_mbed_os_target_name "static-mbed-os-${MBED_TARGET}")
set(mbed_generated_header_target_name "mbed-generated-header-${MBED_TARGET}")

# ----- Target ${static_mbed_os_target_name}

add_library(${static_mbed_os_target_name} STATIC source/mbed-os.cpp)
target_link_libraries(${static_mbed_os_target_name} PUBLIC mbed-os)

# All includes

list_dep_targets(${static_mbed_os_target_name} mbed_os_dependencies)

set(include_files "")
foreach(dep ${mbed_os_dependencies})
  if(NOT TARGET ${dep})
    continue()
  endif()

  get_target_property(includes ${dep} INTERFACE_INCLUDE_DIRECTORIES)
  if (NOT includes)
    continue()
  endif()

  foreach(include ${includes})
    if (IS_DIRECTORY ${include})
      file(GLOB files "${include}/*.h" "${include}/*.hpp")
      foreach(file ${files})
        # If ${file} starts with '/' fullpath = ${file}, else fullpath = ${include}/${file}
        string(FIND ${file} "/" pos)
        if (pos EQUAL 0)
          set(fullpath ${file})
        else()
          string(REPLACE "/" "${CMAKE_CURRENT_SOURCE_DIR}/" fullpath ${file})
        endif()

        if (EXISTS ${fullpath})
          list(APPEND include_files "${fullpath}")
        endif()
      endforeach()
    endif()
  endforeach()
endforeach()

# Unique include files
list(REMOVE_DUPLICATES include_files)

install(
  FILES ${include_files}
  DESTINATION include/StaticMbedOS@${MBED_TARGET}
)

# Install archive
install(
  TARGETS ${static_mbed_os_target_name}
  ARCHIVE DESTINATION lib
)

#* CMake scripts

# ----- StaticMbedOSToolchain
get_target_property(compile_options mbed-os INTERFACE_COMPILE_OPTIONS)
set(include_directories
  ${CMAKE_INSTALL_PREFIX}/include/StaticMbedOS@${MBED_TARGET}
)

get_target_property(compile_definitions mbed-os INTERFACE_COMPILE_DEFINITIONS)
list(APPEND compile_definitions "__MBED__=1")
get_target_property(link_options mbed-os INTERFACE_LINK_OPTIONS)
get_target_property(linker_script mbed-os LINKER_SCRIPT_PATH)

configure_file(
  cmake/StaticMbedOSToolchain.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/StaticMbedOSToolchain-${MBED_TARGET}.cmake
  @ONLY
  )


install(
  FILES
    ${CMAKE_CURRENT_BINARY_DIR}/StaticMbedOSToolchain-${MBED_TARGET}.cmake
    cmake/FindStaticMbedOS.cmake
  DESTINATION share/cmake
)