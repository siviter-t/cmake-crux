# \file testing.cmake
# \author Taylor Siviter
# \version 0.10
# \date February 2015
# \brief CMake testing options.
# \copyright Mozilla Public License, Version 2.0.
# This Source Code Form is subject to the terms of the MPL, v. 2.0. If a copy of the MPL was
# not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
# -------------------------------------------------------------------------------------------- #

cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)
include("cmake-crux/package.cmake")

# ------------- #
# Testing Flags #
# ------------- #

set(test_path ${CMAKE_CURRENT_SOURCE_DIR}/test)
set(use_testing OFF CACHE BOOL "Enable CTest support.")

# ------------------ #
# Option Application #
# ------------------ #

macro(setTestingOptions)
# Sets testing options for the project.
# -------------------------------------------------------------------------------------------- #
  # Check for the testing flag.
  if(use_testing)
    enable_testing(true) # Enables unit testing.
    addOptional(TestSuite)
    message(STATUS "Testing enabled")
  endif()
endmacro()

macro(addTestSources)
# Finds and adds any test sources as testing executables.
# Requires the sources to be placed in the top directory of the test_path.
# -------------------------------------------------------------------------------------------- #
  # Check for the testing flag.
  if(use_testing)
    # Glob all test sources into a list.
    file(GLOB test_src_list "${test_path}/*.cxx")
    # Add each of the sources as executables and tests.
    foreach(test_src ${test_src_list})
      # Get the name of the test.
      get_filename_component(test_name ${test_src} NAME_WE)
      add_executable(${test_name} ${test_src})
      add_test(NAME "${test_name}" COMMAND ${test_name})
    endforeach()
    # Notify the user that the test source(s) have been found and processed.
    message(STATUS "Processed testing source(s)")
  endif()

endmacro()
