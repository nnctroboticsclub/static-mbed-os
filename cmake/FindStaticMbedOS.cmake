find_package(StaticMbedOSInternal REQUIRED)

set(StaticMbedOS_Dummy ${CMAKE_CURRENT_LIST_FILE})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(StaticMbedOS REQUIRED_VARS StaticMbedOS_Dummy)

if(StaticMbedOS_FOUND AND NOT TARGET StaticMbedOS)
  add_library(StaticMbedOS INTERFACE)
  target_link_libraries(StaticMbedOS INTERFACE StaticMbedOSInternal)
  target_link_options(StaticMbedOS INTERFACE "SHELL:-Wl,--whole-archive $<TARGET_FILE:StaticMbedOSInternal> -Wl,--no-whole-archive")
endif()
