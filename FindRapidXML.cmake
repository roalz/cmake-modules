# ---------------------------------------------------------------------------
#
# Find RapidXML headers library
#
# ---------------------------------------------------------------------------
#
# Variables defined by this module:
#
#  RapidXML_FOUND       - True if RapidXML was found
#  RapidXML_INCLUDE_DIR - RapidXML include directories
#
# ---------------------------------------------------------------------------
#
# Use this module by invoking find_package with the form:
#
#   find_package(RapidXML
#     [version] [EXACT]      # Minimum or EXACT version e.g. 1.1.0
#     [REQUIRED]             # Fail with error if RapidXML is not found
#     )
#
#
# Ideas for this module were picked up from various places, including github repositories.
#
# Copyright (c) 2016 Roal Zanazzi
# Distributed under the MIT License (see LICENSE file)
# ---------------------------------------------------------------------------

find_path(RapidXML_INCLUDE_DIR
	rapidxml.hpp
	HINTS ENV RAPIDXML_ROOT
	PATH_SUFFIXES rapidxml)

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set RAPIDXML_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(RapidXML DEFAULT_MSG RapidXML_INCLUDE_DIR)

mark_as_advanced(RapidXML_INCLUDE_DIR)

if(RAPIDXML_FOUND)
	# provide import target:
	add_library(RapidXML::RapidXML INTERFACE IMPORTED)
	set_target_properties(RapidXML::RapidXML PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${RapidXML_INCLUDE_DIR})
endif()
