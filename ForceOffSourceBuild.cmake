# ---------------------------------------------------------------------------
# Force off-source-tree build
#
# Copyright (c) 2016 Roal Zanazzi
# Distributed under the MIT License (see LICENSE file)
# ---------------------------------------------------------------------------

if(WIN32)
  set(RM_COMMAND "del")
else()
  set(RM_COMMAND "rm")
  string(ASCII 27 Esc)
  set(ColorReset "${Esc}[m")
  set(BoldRed     "${Esc}[1;31m")
endif()

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(FATAL_ERROR "
  ${BoldRed}This project requires an out of source build.${ColorReset}
  Remove the file 'CMakeCache.txt' in this directory before continuing, 
  create a separate build directory and run 'cmake project_path [options]'
  from there, e.g.:
    ${RM_COMMAND} CMakeCache.txt
    mkdir build
    cd build
    cmake ..
  ")
endif()
