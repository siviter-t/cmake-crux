# \file paths_cxx.cmake
# \author Taylor Siviter
# \date February 2015
# \brief General path locations for projects
# \copyright Mozilla Public License, Version 2.0.
# This Source Code Form is subject to the terms of the MPL, v. 2.0. If a copy of the MPL was
# not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
# -------------------------------------------------------------------------------------------- #

# -------------- #
# Path locations #
# -------------- #

# Easily overridden if needed by the projects CMakeLists.txt file. Would be a good idea to
# include this file before any others -- to be safe.

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/lib)
set(include_path ${CMAKE_CURRENT_SOURCE_DIR})
set(source_path ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(test_path ${CMAKE_CURRENT_SOURCE_DIR}/test)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake-crux/Modules)

# ------------------------ #
# In-source building guard #
# ------------------------ #

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR "In-source building is not allowed. Try using the arrange script.")
endif()
