#
# Define variables of module groups for use by the sebsjames/maths_config
# build process itself, and by client projects.
#
macro(setup_module_variables_for_maths_config base_directory json_directory maths_directory)

  set(SM_CONFIG_MODULES
    ${maths_directory}/sm/mathconst.cppm
    ${maths_directory}/sm/constexpr_math.cppm
    ${maths_directory}/sm/trait_tests.cppm
    ${maths_directory}/sm/interval.cppm
    ${maths_directory}/sm/polysolve.cppm
    ${maths_directory}/sm/bessel_i0.cppm
    ${maths_directory}/sm/random.cppm
    ${maths_directory}/sm/vec.cppm
    ${maths_directory}/sm/vvec.cppm
    ${maths_directory}/sm/util.cppm
    ${base_directory}/sm/config.cppm
    ${json_directory}/src/modules/json.cppm
  )
  list(REMOVE_DUPLICATES SM_CONFIG_MODULES)

endmacro()
