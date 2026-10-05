#
# This file controls the installation of the header files.
#

# Header installation (list from ls * -1, then re-ordered into functionality groups)
install(
  FILES
  config.cppm
  DESTINATION ${CMAKE_INSTALL_PREFIX}/share/sm
)

# Install the EXPORT so that maths has its own .cmake file and find_package(maths_config) should work
install(FILES maths_config-config.cmake DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake/maths_config)
