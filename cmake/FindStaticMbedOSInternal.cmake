include(TargetDumper)

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
foreach(dir ${STATIC_MBED_OS_INCLUDES})
  if(NOT EXISTS ${dir})
    list(REMOVE_ITEM STATIC_MBED_OS_INCLUDES ${dir})
  endif()
endforeach()

file(READ
  ${StaticMbedOSInternalRoot}/compile-options.txt
  STATIC_MBED_OS_COMPILE_OPTIONS
)

file(READ
  ${StaticMbedOSInternalRoot}/link-options.txt
  STATIC_MBED_OS_LINK_OPTIONS
)
string(REPLACE "\n" ";" STATIC_MBED_OS_LINK_OPTIONS ${STATIC_MBED_OS_LINK_OPTIONS})

file(READ
  ${StaticMbedOSInternalRoot}/mbed-located-at.txt
  MBED_OS_ROOT
)


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

  target_link_options(StaticMbedOSInternal INTERFACE
    ${STATIC_MBED_OS_LINK_OPTIONS}
  )

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
