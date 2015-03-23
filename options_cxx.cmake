# \file options_cxx.cmake
# \author Taylor Siviter
# \version 0.20
# \date February 2015
# \brief Compilation settings for C++ projects using g++/clang++.
# \copyright Mozilla Public License, Version 2.0.
# This Source Code Form is subject to the terms of the MPL, v. 2.0. If a copy of the MPL was
# not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
# -------------------------------------------------------------------------------------------- #

cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)

# --------------------- #
# CXX Compilation Flags #
# --------------------- #

set(use_clang OFF CACHE BOOL "Use clang++ instead of the default compiler, g++.")
set(use_shared OFF CACHE BOOL "Build shared libraries instead of static.")
set(use_cxx14 OFF CACHE BOOL "Use C++14 instead of the default C++11.")
set(use_o2 OFF CACHE BOOL "Optimise compilation output.")
set(use_woff OFF CACHE BOOL "Inhibit all warning messages.")
set(use_werr OFF CACHE BOOL "Turn all warnings into errors.")
set(use_fexp OFF CACHE BOOL "Enables exception handling.")

# ------------------ #
# Option Application #
# ------------------ #

macro(setCompilationOptions)
# Sets compilation options for the project.
# \note Must be used before project setup -- i.e. the project("name" CXX) statement.
# -------------------------------------------------------------------------------------------- #
  # Check for clang compiler setting.
  if(use_clang)
    set(CMAKE_CXX_COMPILER "/usr/bin/clang++") # Use clang++.
  else()
    set(CMAKE_CXX_COMPILER "/usr/bin/g++") # Use g++.
  endif()

  # Fixes system includes setting.
  set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-isystem")

  # Check for shared library setting.
  if(use_shared)
    set(BUILD_SHARED_LIBS ON) # Use shared libs.
  else()
    set(BUILD_SHARED_LIBS OFF) # Use static libs.
  endif()

  # Check for C++ version.
  if(use_cxx14)
    add_compile_options(-std=c++14) # Use C++14.
  else()
    add_compile_options(-std=c++11) # Use C++11.
  endif()

  # Check for optimisation.
  if(use_o2)
    add_compile_options(-O2) # Optimise compilation output.
  endif()

  # Check for warnings.
  if(use_woff)
    add_compile_options(-w) # Inhibit all warning messages.
  else()
    add_compile_options(-Wall) # Enable most warnings.
    add_compile_options(-Wextra) # Enable a few extra warnings.
    add_compile_options(-Wconversion) # Warnings for implicit type conversions.
    add_compile_options(-Wno-comment) # Disable inception comment sequences warning.
  endif()
  if(use_werr)
    add_compile_options(-Werror) # Turn all warnings into errors.
  endif()

  # Check for exceptions.
  if(use_fexp)
    add_compile_options(-fexceptions) # Enable exception handling.
  endif()

  message(STATUS "Compilation options set")

endmacro()
