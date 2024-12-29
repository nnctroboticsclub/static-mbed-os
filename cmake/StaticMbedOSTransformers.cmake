function(static_mbed_os_transform_rules target)
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

  add_custom_target(upload_${target}
    COMMAND sudo -E bash -c 'st-flash --connect-under-reset $$FLASH_ARGS --format ihex write $<TARGET_FILE_BASE_NAME:${target}>.hex'
    DEPENDS ${target}
    COMMENT "Uploading ${target}.bin to device"
    USES_TERMINAL
  )
endfunction()
