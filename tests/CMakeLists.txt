# CTests

# GCC < version 16.1 can't compile sm::config (something to do with the nlohmann::json module). It also seems to be an issue on Windows
if((CMAKE_CXX_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION GREATER_EQUAL 16.1))
  add_executable(config1 config1.cpp)
  target_sources_modules(config1 MODULES ${SM_CONFIG_MODULES})
  add_test(config1 config1)
endif()
