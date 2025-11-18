cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

set(CMAKE_INSTALL_MESSAGE LAZY)
set(MBED_APP_JSON_PATH mbed_app.json)
set(MBED_TOOLCHAIN GCC_ARM)

set(static_mbed_os_target_name "static-mbed-os-${MBED_TARGET}")

include(TargetDumper)
include(DependencyFinder)

include(GccArmToolchain)
include(MbedCE-Toolchain)
include(GccArmToolchain)
string(REPLACE " -Wl,--cref" "" CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT}")

message(STATUS "Using Toolchain")
message(STATUS "  - CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
message(STATUS "  - CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
message(STATUS "  - CMAKE_ASM_COMPILER: ${CMAKE_ASM_COMPILER}")

project(static-mbed-os VERSION 1.0.2 LANGUAGES CXX)
include(MbedCE)

#* Target

add_library(${static_mbed_os_target_name} STATIC mbed-os.cpp)
target_link_libraries(${static_mbed_os_target_name} PRIVATE mbed-os)

#* Dump target info
# Include files
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
    if (NOT IS_DIRECTORY ${include})
      continue()
    endif()

    message(STATUS "include: ${include}")

    # If ${include} contains 'include' in the path, install it as a directory
    # else fallthrough to file installation
    string(FIND ${include} "include" pos)
    string(FIND ${include} "STM32Cube_FW" pos)
    if (pos EQUAL -1)
      message(STATUS "  mode: file")
      set(full_install FALSE)
    else()
      message(STATUS "  mode: directory")
      set(full_install TRUE)
    endif()

    if (${full_install} EQUAL FALSE)
      # Selects file with no extension
      set(remove_list "")
      foreach(file ${files_no_ext})
        # ${file} is a directory, remove it from the list
        if (IS_DIRECTORY ${file})
          message(STATUS "  ${file} is a directory, remove it from the list")
          list(APPEND remove_list "${file}")
          continue()
        endif()

        # ${file} is a file with extension, remove it from the list
        get_filename_component(file_ext ${file} EXT)
        if (NOT file_ext STREQUAL "")
          message(STATUS "  ${file} is a file with extension, remove it from the list")
          list(APPEND remove_list "${file}")
        endif()
      endforeach()
      list(REMOVE_ITEM files_no_ext ${remove_list})

      # Selects *.h or *.hpp
      file(GLOB files_header "${include}/*.h" "${include}/*.hpp")

      set(entries "")
      list(APPEND entries ${files_no_ext})
      list(APPEND entries ${files_header})
    else()
      file(GLOB entries "${include}/*")
    endif()

    list(LENGTH entries num_entries)
    message(STATUS "  num_entries: ${num_entries}")

    set(dirs "")
    set(files "")
    foreach(entry ${entries})
      # ${entry} is a directory, remove it from the list
      if (IS_DIRECTORY ${entry})
        list(APPEND dirs "${entry}")
      else()
        list(APPEND files "${entry}")
      endif()
    endforeach()

    message(STATUS "  files: ${files}")
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

    message(STATUS "  dirs: ${dirs}")
    foreach(dir ${dirs})
      install(
        DIRECTORY ${dir}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
      )
    endforeach()
  endforeach()
endforeach()

list(REMOVE_DUPLICATES include_files)

#* Install
set(STATIC_MBED_OS_INSTALL_NAME "StaticMbedOS-${MBED_TARGET}")

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Archive
install(
  TARGETS ${static_mbed_os_target_name}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# Includes
set(include_directories ${CMAKE_INSTALL_INCLUDEDIR})
install(
  FILES
    ${include_files}
    ${CMAKE_BINARY_DIR}/mbed-ce/generated-headers/mbed-target-config.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# Linker script
get_target_property(linker_script mbed-os LINKER_SCRIPT_PATH)
set(linker_script_installation "${CMAKE_INSTALL_PREFIX}/share/cmake/StaticMbedOS@${MBED_TARGET}.ld")
install(
  FILES ${linker_script}
  DESTINATION ${CMAKE_INSTALL_PREFIX}/share/cmake
  RENAME StaticMbedOS@${MBED_TARGET}.ld
)

# Toolchain file
get_target_property(compile_options_ mbed-os INTERFACE_COMPILE_OPTIONS)
set(compile_options "")
foreach(compile_option ${compile_options_})
  string(REPLACE "${CMAKE_BINARY_DIR}/mbed-ce/generated-headers" "${CMAKE_INSTALL_INCLUDEDIR}" compile_option "${compile_option}")
  list(APPEND compile_options "${compile_option}")
endforeach()

get_target_property(compile_definitions mbed-os INTERFACE_COMPILE_DEFINITIONS)
list(APPEND compile_definitions "__MBED__=1")
get_target_property(link_options mbed-os INTERFACE_LINK_OPTIONS)

configure_file(
  StaticMbedOSToolchain.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/StaticMbedOSToolchain-${MBED_TARGET}.cmake
  @ONLY
)

configure_package_config_file(
  StaticMbedOSConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/StaticMbedOS-${MBED_TARGET}Config.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)

install(
  FILES
    ${CMAKE_CURRENT_BINARY_DIR}/StaticMbedOSToolchain-${MBED_TARGET}.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/StaticMbedOS-${MBED_TARGET}Config.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)

include(./cpack.cmake)