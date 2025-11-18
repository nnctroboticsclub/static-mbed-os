cmake_minimum_required(VERSION 3.19)

project(static-mbed-os-test VERSION 0.1.1)
enable_language(C CXX ASM)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(app main.cpp)
target_link_libraries(app PUBLIC StaticMbedOS)
static_mbed_os_app_target(app)

install(TARGETS app RUNTIME DESTINATION bin)
