cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
  /usr/arm-none-eabi/share/cmake
  /usr/arm-none-eabi/lib/cmake
)
set(CMAKE_INSTALL_MESSAGE LAZY)
set(MBED_APP_JSON_PATH mbed_app.json)
set(MBED_TOOLCHAIN GCC_ARM)

include(MbedCE)
include(TargetDumper)
include(DependencyFinder)

project(static-mbed-os)

# ----- Target Installer
include(CMakePackageConfigHelpers)


function(install_target dep)
  install(TARGETS ${dep}
    EXPORT ${dep}-export
    ARCHIVE        DESTINATION lib
    LIBRARY        DESTINATION lib
    INCLUDES       DESTINATION include
    PUBLIC_HEADER  DESTINATION include/${dep}
  )

  install(EXPORT ${dep}-export
    FILE ${dep}.cmake
    DESTINATION lib/cmake
    EXPORT_LINK_INTERFACE_LIBRARIES
    NAMESPACE mbed-os::
  )

  # Get dependencies
  get_target_property(DEPS ${dep} INTERFACE_LINK_LIBRARIES)
  if(NOT DEPS)
    set(DEPS "")
  endif()

  set(DEP ${dep})
  configure_package_config_file(
    cmake/Config.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/${dep}Config.cmake"
    INSTALL_DESTINATION "lib/cmake"
  )
  unset(DEPS)
  unset(DEP)

  install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/${dep}Config.cmake"
    DESTINATION "lib/cmake"
  )
endfunction()

# ----- Target Names
set(static_mbed_os_target_name "static-mbed-os-${MBED_TARGET}")
set(mbed_generated_header_target_name "mbed-generated-header-${MBED_TARGET}")

# ----- Target

add_library(${static_mbed_os_target_name} STATIC source/mbed-os.cpp)
target_link_libraries(${static_mbed_os_target_name} PUBLIC mbed-os)

list_dep_targets(${static_mbed_os_target_name} mbed_os_dependencies)

set(includes_to_copy "")
foreach(dep ${mbed_os_dependencies})
  if(TARGET ${dep})
    # Fix INTERFACE_INCLUDE_DIRECTORIES (copy generated-headers)
    get_target_property(includes ${dep} INTERFACE_INCLUDE_DIRECTORIES)

    set(use_built_headers FALSE)
    foreach (include_path ${includes})
      if (${include_path} MATCHES "mbed-os")
        list(APPEND includes_to_copy ${include_path})
        set(use_built_headers TRUE)
      endif()
    endforeach()

    list(REMOVE_DUPLICATES includes_to_copy)
    foreach(include_path ${includes_to_copy})
      if (${include_path} IN_LIST includes)
      list(REMOVE_ITEM includes ${include_path})
      endif()
    endforeach()

    if (NOT "${includes}" MATCHES "includes-NOTFOUND")
      set_property(TARGET ${dep} PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${includes})
    endif()


    if(use_built_headers)
      target_link_libraries(${static_mbed_os_target_name} PUBLIC ${mbed_generated_header_target_name})
    endif()

    # Install
    install_target(${dep})
  endif()
endforeach()

# Install
add_library(${mbed_generated_header_target_name} INTERFACE)
foreach(include_path ${includes_to_copy})
  install(
    DIRECTORY ${include_path}
    DESTINATION include/mbed-os/generated-${MBED_TARGET}
  )
endforeach()

target_include_directories(${mbed_generated_header_target_name} INTERFACE
  $<BUILD_INTERFACE:${includes_to_copy}>
  $<INSTALL_INTERFACE:include/mbed-os/generated-${MBED_TARGET}>
)

install_target(${mbed_generated_header_target_name})


install(
  FILES
    cmake/StaticMbedOSTransformers.cmake
  DESTINATION share/cmake
)

string(TOLOWER ${MBED_TARGET} mbed_target)
get_target_property(linker_script mbed-os LINKER_SCRIPT_PATH)
configure_file(
  cmake/UseStaticMbedOS.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/UseStaticMbedOS-${MBED_TARGET}.cmake
  @ONLY
)
unset(linker_script)
unset(mbed_target)

install(
  FILES
    ${CMAKE_CURRENT_BINARY_DIR}/UseStaticMbedOS-${MBED_TARGET}.cmake
  DESTINATION share/cmake
)