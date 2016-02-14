# ---------------------------------------------------------------------------
#
# Find Log4cplus library and headers
#
# ---------------------------------------------------------------------------
#
# Log4cplus libraries come in a few variants encoded in their file name.
# Users or projects may tell this module which variant to find by
# setting the following variables.
# Those variables need to be either set before calling find_package
# or exported as environment variables before running CMake:
#
#  LOG4CPLUS_USE_STATIC_LIBS - Set to ON to force the use of the static
#                              library. Default is OFF.
#  LOG4CPLUS_USE_UNICODE     - Set to ON to force the use of the unicode 
#                              library. Default if OFF.
#
# This module reads hints about search locations from the following variables:
#
#  LOG4CPLUS_ROOT
#  LOG4CPLUS_DIR
#
# ---------------------------------------------------------------------------
#
# Variables defined by this module:
#
#  LOG4CPLUS_FOUND       - True if log4cplus was found
#                          If false, do not try to link to Log4cplus
#  LOG4CPLUS_INCLUDE_DIRS - Path to log4cplus include directory
#  LOG4CPLUS_LIBRARIES   - libraries to link
#
# Additional variables defined:
#
#  LOG4CPLUS_VERSION     - The version of log4cplus found (i.e. 1.2.0)
#  LOG4CPLUS_MAJOR_VERSION - The major version
#  LOG4CPLUS_MINOR_VERSION - The minor version
#  LOG4CPLUS_PATCH_VERSION - The patch version
#
# ---------------------------------------------------------------------------
#
# Use this module by invoking find_package with the form::
#
#   find_package(Log4cplus
#     [version] [EXACT]      # Minimum or EXACT version e.g. 1.1.0
#     [REQUIRED]             # Fail with error if Log4cplus is not found
#     )
#
#
# Ideas for this module were picked up from various places, including github repositories.
#
# Copyright (c) 2016 Roal Zanazzi
# Distributed under the MIT License (see LICENSE file)
# ---------------------------------------------------------------------------

foreach(opt LOG4CPLUS_ROOT LOG4CPLUS_DIR LOG4CPLUS_USE_STATIC_LIBS LOG4CPLUS_USE_UNICODE)
  if(${opt} AND DEFINED ENV{${opt}} AND NOT ${opt} STREQUAL "$ENV{${opt}}")
    message(WARNING "Conflicting ${opt} values: ignoring environment variable and using CMake cache entry.")
  elseif(DEFINED ENV{${opt}} AND NOT ${opt})
    set(${opt} "$ENV{${opt}}")
  endif()
endforeach()

# Find include path
find_path(LOG4CPLUS_INCLUDE_DIRS
  NAMES logger.h
  PATH_PREFIXES log4cplus
  PATH_SUFFIXES include
  HINTS
    ${LOG4CPLUS_DIR}
    ${LOG4CPLUS_ROOT}
  PATHS
    /usr/local
    /usr
    /opt/local
    /opt/csw
    /opt
)

# Extract version information from version.h
if(LOG4CPLUS_INCLUDE_DIRS AND EXISTS "${LOG4CPLUS_INCLUDE_DIRS}/log4cplus/version.h")
  file(STRINGS "${LOG4CPLUS_INCLUDE_DIRS}/log4cplus/version.h" _LOG4CPLUS_VERSION_H_CONTENTS REGEX ".*#define[ ]+LOG4CPLUS_VERSION[ ]+")
  string(REGEX MATCHALL "[0-9]+" _LOG4CPLUS_VER_LIST "${_LOG4CPLUS_VERSION_H_CONTENTS}")
  list(LENGTH _LOG4CPLUS_VER_LIST _LOG4CPLUS_VER_LIST_LEN)
  # we also count '4' from the name...
  if(_LOG4CPLUS_VER_LIST_LEN EQUAL 5)
    list(GET _LOG4CPLUS_VER_LIST 2 LOG4CPLUS_MAJOR_VERSION)
    list(GET _LOG4CPLUS_VER_LIST 3 LOG4CPLUS_MINOR_VERSION)
    list(GET _LOG4CPLUS_VER_LIST 4 LOG4CPLUS_PATCH_VERSION)
  endif()
  unset(_LOG4CPLUS_VERSION_H_CONTENTS)
  unset(_LOG4CPLUS_VER_LIST)
  unset(_LOG4CPLUS_VER_LIST_LEN)
  set(LOG4CPLUS_VERSION "${LOG4CPLUS_MAJOR_VERSION}.${LOG4CPLUS_MINOR_VERSION}.${LOG4CPLUS_PATCH_VERSION}")
  message(STATUS "Log4cplus version: ${LOG4CPLUS_VERSION}")
endif()

# Find debug and release libraries with appropriate postfixes for the requested variant
if(LOG4CPLUS_USE_STATIC_LIBS)
    set(log4cplus_postfix "${log4cplus_postfix}S")
endif()
if(LOG4CPLUS_USE_UNICODE)
    set(log4cplus_postfix "${log4cplus_postfix}U")
endif()

set(LOG4CPLUS_LIB_NAMES_RELEASE "log4cplus${log4cplus_postfix}")
set(LOG4CPLUS_LIB_NAMES_DEBUG "log4cplus${log4cplus_postfix}D")

find_library(LOG4CPLUS_RELEASE_LIBRARY
  NAMES ${LOG4CPLUS_LIB_NAMES_RELEASE}
  HINTS
    ${LOG4CPLUS_DIR}
    ${LOG4CPLUS_ROOT}
  PATH_SUFFIXES lib64 lib
  PATHS
    /usr/local
    /usr
    /sw
    /opt/local
    /opt/csw
    /opt
  NO_DEFAULT_PATH
)

find_library(LOG4CPLUS_DEBUG_LIBRARY
  NAMES ${LOG4CPLUS_LIB_NAMES_DEBUG}
  HINTS
    ${LOG4CPLUS_DIR}
    ${LOG4CPLUS_ROOT}
  PATH_SUFFIXES lib64 lib
  PATHS
    /usr/local
    /usr
    /sw
    /opt/local
    /opt/csw
    /opt
  NO_DEFAULT_PATH
)

if(LOG4CPLUS_RELEASE_LIBRARY)
	if(LOG4CPLUS_DEBUG_LIBRARY)
		set(LOG4CPLUS_LIBRARIES debug ${LOG4CPLUS_DEBUG_LIBRARY} optimized ${LOG4CPLUS_RELEASE_LIBRARY} CACHE STRING "Log4cplus Libraries")
    else(LOG4CPLUS_DEBUG_LIBRARY)
		set(LOG4CPLUS_LIBRARIES ${LOG4CPLUS_RELEASE_LIBRARY} CACHE STRING "Log4cplus Libraries")
    endif()
endif()

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set LOG4CPLUS_FOUND to TRUE if 
# all listed variables are TRUE
find_package_handle_standard_args(Log4cplus FOUND_VAR LOG4CPLUS_FOUND
	REQUIRED_VARS LOG4CPLUS_LIBRARIES LOG4CPLUS_INCLUDE_DIRS
	VERSION_VAR LOG4CPLUS_VERSION)

mark_as_advanced(LOG4CPLUS_INCLUDE_DIRS LOG4CPLUS_LIBRARIES LOG4CPLUS_DEBUG_LIBRARY LOG4CPLUS_RELEASE_LIBRARY)
