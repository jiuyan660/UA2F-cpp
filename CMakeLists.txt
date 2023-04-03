cmake_minimum_required(VERSION 3.16)
project(UA2F CPP)

set(CMAKE_CXX_STANDARD 17)

include_directories("/usr/local/include")

add_compile_options(-fsanitize=address)
add_link_options(-fsanitize=address)

add_executable(ua2f src/ua2f.cpp)

target_link_libraries(ua2f lmnl lnetfilter_queue lnfnetlink lpthread)

install(TARGETS ua2f RUNTIME DESTINATION bin)
