#.rst:
# FindGLib
# ----------
#
# CMake macros to find and use the GLib 2.x library and tools
#
# The following functions are provided by this module:
#
# ::
#
#   gdbus_generate_c_code
#   glib_add_enums_from_template
#   glib_generate_marshal
#
# Output variables:
#
#   GLIB_FOUND            ... set to 1 if GLib 2.x was found
#
# If GLIB_FOUND == 1:
#
#   GLIB_VERSION
#
#   GDBUS_CODEGEN         ... the location of the gdbus-codegen executable
#   GLIB_COMPILE_SCHEMAS  ... the location of the glib-compile-schemas executable
#   GLIB_GENMARSHAL       ... the location of the glib-genmarshal executable
#   GLIB_MKENUMS          ... the location of the glib-mkenums executable
#
#   GLIB_CFLAGS
#   GLIB_CFLAGS_OTHER
#   GLIB_INCLUDEDIR
#   GLIB_INCLUDE_DIRS
#   GLIB_LDFLAGS
#   GLIB_LDFLAGS_OTHER
#   GLIB_LIBRARIES
#   GLIB_LIBDIR
#   GLIB_LIBRARY_DIRS
#   GLIB_PREFIX
#

#=============================================================================
# Copyright 2015 Lautsprecher Teufel GmbH
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)


include(FindPackageHandleStandardArgs)

find_package(PkgConfig REQUIRED)

pkg_check_modules(
    GLib REQUIRED
        glib-2.0>=${glib_required_version}
        gobject-2.0 gio-2.0 gthread-2.0)

find_program(GDBUS_CODEGEN gdbus-codegen PATH "${GLib_PREFIX}/bin")
find_program(GLIB_GENMARSHAL glib-genmarshal PATH "${GLib_PREFIX}/bin")
find_program(GLIB_MKENUMS glib-mkenums PATH "${GLib_PREFIX}/bin")

set(GLib_VERSION ${GLib_glib-2.0_VERSION})

set(GLIB_VERSION ${GLib_glib-2.0_VERSION})
set(GLIB_INCLUDEDIR ${GLib_INCLUDEDIR})
set(GLIB_LIBDIR ${GLib_LIBDIR})
set(GLIB_PREFIX ${GLib_PREFIX})
set(GLIB_CFLAGS ${GLib_CFLAGS_OTHER})
set(GLIB_CFLAGS_OTHER ${GLib_CFLAGS_OTHER})
set(GLIB_INCLUDE_DIRS ${GLib_INCLUDE_DIRS})
set(GLIB_LDFLAGS ${GLib_LDFLAGS})
set(GLIB_LDFLAGS_OTHER ${GLib_LDFLAGS_OTHER})
set(GLIB_LIBRARIES ${GLib_LIBRARIES})
set(GLIB_LIBRARY_DIRS ${GLib_LIBRARY_DIRS})

find_package_handle_standard_args(GLib
    REQUIRED_VARS GLib_LIBRARIES GDBUS_CODEGEN GLIB_GENMARSHAL GLIB_MKENUMS
    VERSION_VAR GLib_VERSION)

# ::
#
# gdbus_generate_c_code(source interface_prefix output_basename)
#
# The GDBUS_CODEGEN variable should point to the `gdbus-codegen` program.
#
# You will need to ensure that the generated C code in the binary
# directory can find the header file in the source directory, so that
# srcdir != builddir builds work correctly. This can be done either by
# calling `include_directories (${CMAKE_CURRENT_SOURCE_DIR})`, or by
# calling `SET(CMAKE_INCLUDE_CURRENT_DIR ON)`.
#
# Example:
#
#   gdbus_generate_c_code (com.example.plugh.xml com.example.plugh ${CMAKE_CURRENT_BINARY_DIR}/plugh)
#
# This would generate plugh.c and plugh.h from the input file
# com.example.plugh.xml.
#
macro(gdbus_generate_c_code _source _interface_prefix _output_basename)
    add_custom_command(
        OUTPUT
            ${_output_basename}.h ${_output_basename}.c
        COMMAND
            ${GDBUS_CODEGEN} --generate-c-code ${_output_basename} --interface-prefix ${_interface_prefix} ${_source}
        DEPENDS
            ${_source}
        WORKING_DIRECTORY
            ${CMAKE_CURRENT_SOURCE_DIR}
        VERBATIM)
endmacro(gdbus_generate_c_code)


# glib_add_enums_from_template (source template target)
#
# The GLIB_MKENUMS variable should be set to point to the `glib-mkenums`
# program.
#
# You will need to ensure that the generated C code in the binary
# directory can find the header file in the source directory, so that
# srcdir != builddir builds work correctly. This can be done either by
# calling `include_directories (${CMAKE_CURRENT_SOURCE_DIR})`, or by
# calling `SET(CMAKE_INCLUDE_CURRENT_DIR ON)`.
#
# Example:
#
#   glib_add_enums_from_template (
#       foo-enums.h foo-enums.c.template
#       ${CMAKE_CURRENT_BINARY_DIR}/foo-enums.c)
#
macro(glib_add_enums_from_template _source _template _target)
    add_custom_command(
        OUTPUT
            ${_target}
        COMMAND
            ${GLIB_MKENUMS} --template ${_template} ${_source} > ${_target}
        WORKING_DIRECTORY
            ${CMAKE_CURRENT_SOURCE_DIR}
        DEPENDS
            ${_source} ${_template}
        VERBATIM)
endmacro(glib_add_enums_from_template)


# glib_generate_marshal (source prefix output_basename)
#
# The GLIB_GENMARSHAL variable should point to the `glib-genmarshal` program.
#
# You will need to ensure that the generated C code in the binary
# directory can find the header file in the source directory, so that
# srcdir != builddir builds work correctly. This can be done either by
# calling `include_directories (${CMAKE_CURRENT_SOURCE_DIR})`, or by
# calling `SET(CMAKE_INCLUDE_CURRENT_DIR ON)`.
#
# Example:
#
#   glib_generate_marshal (foo-marshal.list foo ${CMAKE_CURRENT_BINARY_DIR}/foo-marshal)
#
# This would generate foo-marshal.c and foo-marshal.h from the input file
# foo-marshal.list.
#
# FIXME: this isn't really needed with modern versions of GLIB due to a 
# special marshal function you can use.
macro(glib_generate_marshal _source _prefix _output_basename)
    get_filename_component(_output_basename_name "${_output_basename}" NAME)

    add_custom_command(
        OUTPUT
            ${_output_basename}.h
        COMMAND
            ${GLIB_GENMARSHAL} --prefix=${_prefix} ${_source} --header > ${_output_basename}.h
        WORKING_DIRECTORY
            ${CMAKE_CURRENT_SOURCE_DIR}
        DEPENDS
            ${_source}
        VERBATIM)

    add_custom_command(
        OUTPUT
            ${_output_basename}.c
        COMMAND
            echo "#include \"${_output_basename_name}.h\"" > ${_output_basename}.c &&
            ${GLIB_GENMARSHAL} --prefix=${_prefix} ${_source} --body >> ${_output_basename}.c
        WORKING_DIRECTORY
            ${CMAKE_CURRENT_SOURCE_DIR}
        DEPENDS
            ${_source}
        VERBATIM)
endmacro(glib_generate_marshal)
