# 3.28.5 for basic C++20 modules; 3.30 to give access to import std;
cmake_minimum_required(VERSION 3.28.5)

# For future import std; support:
# This specific value changes as experimental support evolves. See
# `Help/dev/experimental.rst` in the CMake source corresponding to
# your CMake build for the exact value to use.
# This value is ok for cmake versions from 3.31.11 up to 4.2.3 (Seb)
# set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")

project(maths_config LANGUAGES CXX)

message(STATUS "Install prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "  (This can be changed with `cmake -DCMAKE_INSTALL_PREFIX=/some/place`")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# For clang and future import std; support
# set(CMAKE_CXX_EXTENSIONS ON)

# For future import std; support:
# Tell CMake that we explicitly want `import std`. This will initialize the
# property on all targets declared after this to 1
# set(CMAKE_CXX_MODULE_STD 1)

# Defines our C++ module code file lists (such as SM_VEC_MODULES)
include(${PROJECT_SOURCE_DIR}/cmake/module_definitions.cmake)

# Add the host definition to CXXFLAGS along with other switches
if (APPLE)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -O3")
else()
  if(CMAKE_CXX_COMPILER_ID MATCHES MSVC OR CMAKE_CXX_COMPILER_FRONTEND_VARIANT MATCHES MSVC)
    # Set flags for Windows.
    # -DNOMINMAX to prefer std::min and std::max
    # /EHsc required for use of exceptions
    # /Zc:__cplusplus ensures __cplusplus define does not lie
    # /constexpr:steps is equivalent to -fconstexpr-steps or -fconstexpr-ops-limit
    if(CMAKE_CXX_COMPILER_ID MATCHES MSVC)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DNOMINMAX /EHsc /Zc:__cplusplus /constexpr:steps500000000")
    else()
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DNOMINMAX /EHsc /Zc:__cplusplus")
    endif()
  elseif(CMAKE_CXX_COMPILER_ID MATCHES Intel)
    # To use Intel compiler, you can call cmake as: `cmake -DCMAKE_CXX_COMPILER=icpc ..` or `CXX=icpc cmake ..`
    message(WARNING "Intel compiler has not been tested for some time")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -std=c++20 -xHOST -O3")
  else() # GCC or Clang
    if(CMAKE_CXX_COMPILER_ID MATCHES Clang)
      if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 18)
        message(FATAL_ERROR "Clang version must be at least 18")
      else()
        message(STATUS "Clang version ${CMAKE_CXX_COMPILER_VERSION} OK!")
      endif()
    elseif(CMAKE_CXX_COMPILER_ID MATCHES GNU)
      # Add compiler version check, to ensure gcc is version 11 or later.
      if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 14)
        message(FATAL_ERROR "GCC version must be at least 14")
      else()
        message(STATUS "GCC version ${CMAKE_CXX_COMPILER_VERSION} OK!")
      endif()
    endif()

    set(COMPREHENSIVE_WARNING_FLAGS "-Wall -Wextra -Wpedantic -pedantic-errors -Werror -Wfatal-errors -Wno-psabi -Wno-unknown-pragmas")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g ${COMPREHENSIVE_WARNING_FLAGS} -O3")
    if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
      # Make it possible to compile complex constexpr functions (gcc only)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fconstexpr-ops-limit=5000000000")
    else()
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fconstexpr-steps=500000000")
    endif()
  endif()
endif()

# In Visual Studio, if CMAKE_BUILD_TYPE is "Debug", some programs will run very slowly
if(WIN32)
  set(CMAKE_BUILD_TYPE "Release")
endif(WIN32)

# Lib finding

# nlohmann::json module json.cppm is submoduled for use with sm::config
include_directories("${PROJECT_SOURCE_DIR}/json/include")

# A macro to make a list of modules into a unique list then add them to target_name
function(target_sources_modules target_name)
  # Parse function args for MODULES
  set(multiValueArgs MODULES)
  cmake_parse_arguments(PARSE_ARGV 0 arg "" "" "${multiValueArgs}")
  # Uniqueify arg_MODULES:
  list(REMOVE_DUPLICATES arg_MODULES)
  target_sources(${target_name} PUBLIC FILE_SET CXX_MODULES BASE_DIRS ${PROJECT_SOURCE_DIR} FILES ${arg_MODULES})
endfunction()

#
# Module groups. see module_definitions.cmake
#
setup_module_variables_for_maths_config (${PROJECT_SOURCE_DIR} ${PROJECT_SOURCE_DIR}/json ${PROJECT_SOURCE_DIR}/maths)

# The sm.config module is here
add_subdirectory(sm)

# Unit testing using the ctest framework
option(BUILD_TESTS "Build tests" ON)
if(BUILD_TESTS)
  enable_testing()
  add_subdirectory(tests)
endif(BUILD_TESTS)

# For debugging of variables:
option(DEBUG_VARIABLES OFF)
if(DEBUG_VARIABLES)
  get_cmake_property(_variableNames VARIABLES)
  foreach(_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
  endforeach()
endif(DEBUG_VARIABLES)
