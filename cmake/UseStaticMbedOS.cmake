find_package(StaticMbedOS REQUIRED)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
  ${MBED_OS_ROOT}/tools/cmake
)
set(MBED_TOOLCHAIN GCC_ARM)
include(${StaticMbedOSInternalRoot}/mbed_config.cmake)
include(mbed_toolchain)

function(static_mbed_os_app_target target)
  target_link_options(${target} PRIVATE "-T" "${StaticMbedOSInternalRoot}/linker_script.ld")
  set_property(TARGET ${target} APPEND PROPERTY LINK_DEPENDS ${StaticMbedOSInternalRoot}/linker_script.ld)

  # Generate .bin from .elf
  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${target}> $<TARGET_FILE_BASE_NAME:${target}>.bin
    COMMENT "Generating ${target}.bin"
  )

  # Generate .hex from .elf
  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${target}> $<TARGET_FILE_BASE_NAME:${target}>.hex
    COMMENT "Generating ${target}.hex"
  )

  # Generate .lst from .elf
  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND ${CMAKE_OBJDUMP} -S $<TARGET_FILE:${target}> > $<TARGET_FILE_BASE_NAME:${target}>.lst
    COMMENT "Generating ${target}.lst"
  )
endfunction()