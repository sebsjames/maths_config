# A config class for Seb's maths library

This repository contains `sm::config`, a C++-20 module that reads JSON-encoded configuration files for numerical simulations.
It is a component in many of Seb's scientific programs.

## Dependencies

`sm::config` uses `nlohmann::json` to read/write JSON. The nlohmann code is compiled as a module. It also uses `sm::vec` and `sm::vvec`, so it requires sebsjames/maths.

## Build requirements

The build requirements are the same as sebsjames/maths, so see that readme for details. The build process is identical.
