# Called be after project()

# Assume MBedCE-Toolchain is already included before project()

include(mbed_project_setup)
add_subdirectory(${mbed-ce_SOURCE_DIR} mbed-ce)
