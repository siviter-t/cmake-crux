# \file package.cmake
# \author Taylor Siviter
# \version 0.2.6
# \date March 2015
# \copyright Mozilla Public License, Version 2.0.
# This Source Code Form is subject to the terms of the MPL, v. 2.0. If a copy of the MPL was
# not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
# -------------------------------------------------------------------------------------------- #

cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)
include(CMakePackageConfigHelpers)

# --------------------- #
# Package Configuration #
# --------------------- #

macro(packageHeaderProject X)
  # Configures the current project into a package so that other projects can find it.
  # \param X -- Project (name) to package.
  # ------------------------------------------------------------------------------------------ #
  # set(sysconfig_install_dir etc/${PROJECT_NAME}/) # Here for later use

  # Get a list of the include paths
  get_property(include_list DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)

  # Configure the ProjectConfig.cmake file
  configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmakerc/packageHeaderConfig.cmake.in"
    "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION ${LIBRARY_OUTPUT_PATH}/${PROJECT_NAME}/cmake
    PATH_VARS include_list # sysconfig_install_dir
    )

  export(PACKAGE ${PROJECT_NAME})

  install(
    FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    DESTINATION ${LIBRARY_OUTPUT_PATH}/${PROJECT_NAME}/cmake
    )
endmacro()

macro(packageSourceProject X)
  # Configures the current project into a package so that other projects can find it.
  # \param X -- Project (name) to package.
  # ------------------------------------------------------------------------------------------ #
  # set(sysconfig_install_dir etc/${PROJECT_NAME}/) # Here for later use.

  # Get a list of the include paths
  get_property(include_list DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
  
  # Configure the ProjectConfig.cmake file 
  configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmakerc/packageSourceConfig.cmake.in"
    "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION ${LIBRARY_OUTPUT_PATH}/${PROJECT_NAME}/cmake
    PATH_VARS include_list # sysconfig_install_dir
    )

  export(PACKAGE ${PROJECT_NAME})
  export(
    TARGETS ${PROJECT_NAME}
    FILE "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Targets.cmake"
    )

  install(
    FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Targets.cmake
    DESTINATION ${LIBRARY_OUTPUT_PATH}/${PROJECT_NAME}/cmake
    )
endmacro()

macro(addIncludes X)
  # Try and add the include directories of the given package.
  # \param x -- Package to find includes for, e.g. Eigen3 or GSL.
  # ------------------------------------------------------------------------------------------ #
  string(TOUPPER ${X} Y) # Package name string in uppercase.
  set(Y_Include_Added FALSE) # Has an include path been found?
  set(IncList "${${X}_INCLUDE};${${X}_INCLUDES};${${X}_INCLUDE_DIR};${${X}_INCLUDE_DIRS}"
    "${${Y}_INCLUDE};${${Y}_INCLUDES};${${Y}_INCLUDE_DIR};${${Y}_INCLUDE_DIRS}")
  foreach(Inc ${IncList})
    # Check the usual variable names for the include paths.
    if(NOT "${Inc}" STREQUAL "")
      # Weed out the empty variables.
      if(${Inc} MATCHES "/usr/local/include/*" OR ${Inc} MATCHES "/usr/include/*")
        # Check if the path is a system installation.
        include_directories(SYSTEM ${Inc})
        message(STATUS "Added system include path >> ${Inc}")
      else()
        # Otherwise the path is local.
        include_directories(${Inc})
        message(STATUS "Added local include path >> ${Inc}")
      endif()
      # Set the include added flag.
      set(Y_Include_Added TRUE)
    endif()
  endforeach()
  # Check for no includes found!
  if(NOT ${Y_Include_Added})
    message(WARNING "Include path variable(s) not found for dependency: ${X}")
  endif(NOT ${Y_Include_Added})
endmacro()

macro(addDependency X)
  # Search the available cmake packages for the given dependency; if found, add any includes.
  # Will error and abort if not found.
  # \param X -- Dependency to find.
  # ------------------------------------------------------------------------------------------ #
  string(TOUPPER ${X} Y) # Package name string in uppercase.
  find_package(${X} REQUIRED)
  if("${${X}_FOUND}" OR "${${Y}_FOUND}")
    message(STATUS "Found dependency: ${X}")
    addIncludes(${X})
  else()
    message(WARNING "Could not find required dependency: ${X}")
    message(FATAL_ERROR "Abort.")
  endif("${${X}_FOUND}" OR "${${Y}_FOUND}")
endmacro()

macro(addOptional X)
  # Search the available cmake packages for the given optional dependency; if found, add any
  # includes. Will notify if not found.
  # \param X -- Optional dependency to find.
  # ------------------------------------------------------------------------------------------ #
  string(TOUPPER ${X} Y) # Package name string in uppercase.
  find_package(${X})
  if("${${X}_FOUND}" OR "${${Y}_FOUND}")
    message(STATUS "Found optional dependency: ${X}")
    addIncludes(${X})
  else()
    message(WARNING "Could not find optional dependency: ${X}")
  endif("${${X}_FOUND}" OR "${${Y}_FOUND}")
endmacro()

macro(addSubTreeDependency X)
  # Search for the given subtree dependency; if found, add the includes. Will error and abort
  # if not found.
  # \param X -- Dependency to find.
  # ------------------------------------------------------------------------------------------ #
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${X}")
    message(STATUS "Found subtree dependency: ${X}")
    include_directories("${CMAKE_CURRENT_SOURCE_DIR}/${X}")
  else()
    message(WARNING "Could not find required subtree dependency: ${X}")
    message(FATAL_ERROR "Abort.")
  endif()
endmacro()
