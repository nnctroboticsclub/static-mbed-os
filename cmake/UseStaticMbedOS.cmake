include(MbedCE)

find_package(StaticMbedOS REQUIRED)

function(static_mbed_os_app_target target)
  get_target_property(LINKER_SCRIPT_PATH mbed-os LINKER_SCRIPT_PATH)

  target_link_options(${target} PRIVATE "-T" "${LINKER_SCRIPT_PATH}")
  set_property(TARGET ${target} APPEND PROPERTY LINK_DEPENDS ${LINKER_SCRIPT_PATH})

  mbed_generate_bin_hex(${target})
endfunction()