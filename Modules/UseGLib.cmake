#.rst:
# UseGlib
# -------
#
# Functions for use with the GLib library.
#
# The following functions are provided by this module:
#
# ::
#
#   gdbus_generate_c_code
#   glib_add_enums_from_template
#   glib_generate_marshal

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
