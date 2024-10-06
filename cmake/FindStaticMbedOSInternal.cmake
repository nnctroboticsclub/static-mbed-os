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

# ----- Properties

set(StaticMbedOSInternalRoot ${CMAKE_CURRENT_LIST_DIR}/mbed-os@3297bae)

set(StaticMbedOSInternalArchive
  ${StaticMbedOSInternalRoot}/libstatic-mbed-os-${MBED_TARGET}.a
)

set(StaticMbedOSInternalAllocWrappers
  ${StaticMbedOSInternalRoot}/mbed_alloc_wrappers.obj
)


file(READ
  ${StaticMbedOSInternalRoot}/definitions.txt
  STATIC_MBED_OS_DEFINITIONS
)
string(REPLACE "\n" ";" STATIC_MBED_OS_DEFINITIONS ${STATIC_MBED_OS_DEFINITIONS})

file(READ
  ${StaticMbedOSInternalRoot}/includes.txt
  STATIC_MBED_OS_INCLUDES
)
string(REPLACE "\n" ";" STATIC_MBED_OS_INCLUDES ${STATIC_MBED_OS_INCLUDES})

file(READ
  ${StaticMbedOSInternalRoot}/compile-options.txt
  STATIC_MBED_OS_COMPILE_OPTIONS
)
string(REPLACE "\n" ";" STATIC_MBED_OS_COMPILE_OPTIONS ${STATIC_MBED_OS_COMPILE_OPTIONS})

file(READ
  ${StaticMbedOSInternalRoot}/link-libraries.txt
  STATIC_MBED_OS_LINK_LIBRARIES
)
string(REPLACE "\n" ";" STATIC_MBED_OS_LINK_LIBRARIES ${STATIC_MBED_OS_LINK_LIBRARIES})

file(READ
  ${StaticMbedOSInternalRoot}/link-options.txt
  STATIC_MBED_OS_LINK_OPTIONS
)
string(REPLACE "\n" ";" STATIC_MBED_OS_LINK_OPTIONS ${STATIC_MBED_OS_LINK_OPTIONS})


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(StaticMbedOSInternal REQUIRED_VARS
  StaticMbedOSInternalArchive
)

if(StaticMbedOSInternal_FOUND AND NOT TARGET StaticMbedOSInternal)
  add_library(StaticMbedOSInternal UNKNOWN IMPORTED)
  set_target_properties(StaticMbedOSInternal PROPERTIES
    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
    IMPORTED_LOCATION "${StaticMbedOSInternalArchive}"
  )

  target_include_directories(StaticMbedOSInternal INTERFACE
    ${STATIC_MBED_OS_INCLUDES}
  )

  target_compile_definitions(StaticMbedOSInternal INTERFACE
    ${STATIC_MBED_OS_DEFINITIONS}
  )
  target_compile_definitions(StaticMbedOSInternal INTERFACE
    __MBED__
  )

  target_compile_options(StaticMbedOSInternal INTERFACE
    ${STATIC_MBED_OS_COMPILE_OPTIONS}
  )

  target_link_libraries(StaticMbedOSInternal INTERFACE
    ${STATIC_MBED_OS_LINK_LIBRARIES}
    # ${StaticMbedOSInternalAllocWrappers}
  )

  target_link_options(StaticMbedOSInternal INTERFACE
    ${STATIC_MBED_OS_LINK_OPTIONS}
  )

  print_target_properties(StaticMbedOSInternal)

  set_target_properties(StaticMbedOSInternal PROPERTIES
    BUILD_WITH_INSTALL_RPATH OFF
    CXX_EXTENSIONS TRUE
    CXX_STANDARD 17
    C_EXTENSIONS TRUE
    C_STANDARD 11
    EXCLUDE_FROM_ALL TRUE
    LINK_LIBRARIES "mbed-nucleo-f446re;mbed-core-flags;mbed-core-sources;mbed-rtos-flags;mbed-rtos-sources;mbed-stm32f446xe;mbed-stm32f4;mbed-stm;mbed-stm32f4cube-fw;mbed-cmsis-cortex-m"
  )
endif()
