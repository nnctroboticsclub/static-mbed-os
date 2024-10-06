cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

# set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} /workspaces/nhk-2024-b/common_libs)
set(CMAKE_INSTALL_MESSAGE LAZY)
set(MBED_APP_JSON_PATH mbed_app.json)
set(MBED_TOOLCHAIN GCC_ARM)

include(mbed-os/tools/cmake/app.cmake)
add_subdirectory(mbed-os)

project(static-mbed-os)

# ----- dumper

# Get all propreties that cmake supports
if(NOT CMAKE_PROPERTY_LIST)
    execute_process(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

    # Convert command output into a CMake list
    string(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
    string(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
    list(REMOVE_DUPLICATES CMAKE_PROPERTY_LIST)
endif()

function(print_properties)
    message("CMAKE_PROPERTY_LIST = ${CMAKE_PROPERTY_LIST}")
endfunction()

function(print_target_properties target)
    if(NOT TARGET ${target})
      message(STATUS "There is no target named '${target}'")
      return()
    endif()

    foreach(property ${CMAKE_PROPERTY_LIST})
        string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" property ${property})

        # Fix https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
        if(property STREQUAL "LOCATION" OR property MATCHES "^LOCATION_" OR property MATCHES "_LOCATION$")
            continue()
        endif()

        get_property(was_set TARGET ${target} PROPERTY ${property} SET)
        if(was_set)
            get_target_property(value ${target} ${property})
            message("${target} ${property} = ${value}")
        endif()
    endforeach()
endfunction()

# ----- Target

add_library(static-mbed-os-${MBED_TARGET} STATIC
  source/mbed-os.cpp
)
target_link_libraries(static-mbed-os-${MBED_TARGET} PUBLIC
  mbed-os
)
install(
  TARGETS static-mbed-os-${MBED_TARGET}
  ARCHIVE DESTINATION share/cmake/mbed-os@3297bae/
)

print_target_properties(mbed-os)

# ---- Install Headers

get_target_property(MBED_OS_INCLUDE1 mbed-os         INTERFACE_INCLUDE_DIRECTORIES)
get_target_property(MBED_OS_INCLUDE3 mbed-core-flags INTERFACE_INCLUDE_DIRECTORIES)

set(MBED_OS_INCLUDES
  ${MBED_OS_INCLUDE1}
  ${MBED_OS_INCLUDE3}
)
list(REMOVE_DUPLICATES MBED_OS_INCLUDES)

foreach(dir ${MBED_OS_INCLUDES})
  if(NOT EXISTS ${dir})
    list(REMOVE_ITEM MBED_OS_INCLUDES ${dir})
    message(WARNING "Directory not found: ${dir}")
  endif()
endforeach()

list(JOIN MBED_OS_INCLUDES "\n" MBED_OS_INCLUDES)
file(WRITE ${CMAKE_BINARY_DIR}/includes.txt "${MBED_OS_INCLUDES}")

install(
  FILES ${CMAKE_BINARY_DIR}/includes.txt
  DESTINATION share/cmake/mbed-os@3297bae
)

# ----- Definitions

get_target_property(definitions mbed-os INTERFACE_COMPILE_DEFINITIONS)

list(JOIN definitions "\n" definitions)

file(WRITE ${CMAKE_BINARY_DIR}/definitions.txt "${definitions}")
install(
  FILES ${CMAKE_BINARY_DIR}/definitions.txt
  DESTINATION share/cmake/mbed-os@3297bae
)

# ----- Compile Options

get_target_property(compile_options mbed-os INTERFACE_COMPILE_OPTIONS)

list(JOIN compile_options "\n" compile_options)

file(WRITE ${CMAKE_BINARY_DIR}/compile-options.txt "${compile_options}")
install(
  FILES ${CMAKE_BINARY_DIR}/compile-options.txt
  DESTINATION share/cmake/mbed-os@3297bae
)

# ----- Link Libraries

get_target_property(link_libraries mbed-os INTERFACE_LINK_LIBRARIES)

list(JOIN link_libraries "\n" link_libraries)

file(WRITE ${CMAKE_BINARY_DIR}/link-libraries.txt "${link_libraries}")
install(
  FILES ${CMAKE_BINARY_DIR}/link-libraries.txt
  DESTINATION share/cmake/mbed-os@3297bae
)

# ----- Link Libraries

get_target_property(link_options mbed-os INTERFACE_LINK_OPTIONS)

list(JOIN link_options "\n" link_options)

file(WRITE ${CMAKE_BINARY_DIR}/link-options.txt "${link_options}")
install(
  FILES ${CMAKE_BINARY_DIR}/link-options.txt
  DESTINATION share/cmake/mbed-os@3297bae
)

# ----- linkerscript

get_target_property(linker_script_path mbed-os LINKER_SCRIPT_PATH)
install(
  FILES ${linker_script_path}
  DESTINATION share/cmake/mbed-os@3297bae
  RENAME linker_script.ld
)

# ----- alloc

install(
  FILES $<FILTER:$<TARGET_OBJECTS:mbed-os>,INCLUDE,mbed_alloc_wrappers>
  DESTINATION share/cmake/mbed-os@3297bae
  RENAME mbed_alloc_wrappers.obj
)



# ----- Find Package
install(
  FILES cmake/FindStaticMbedOS.cmake
  DESTINATION share/cmake
)
install(
  FILES cmake/FindStaticMbedOSInternal.cmake
  DESTINATION share/cmake
)
install(
  FILES cmake/UseStaticMbedOS.cmake
  DESTINATION share/cmake
)

