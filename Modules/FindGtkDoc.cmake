#.rst:
# FindGtkDoc
# ----------
#
# CMake macros to find the GtkDoc documentation system

# Output variables:
#
#   GTKDOC_FOUND            ... set to 1 if GtkDoc was foung
#
# If GTKDOC_FOUND == 1:
#
#   GTKDOC_SCAN_EXE         ... the location of the gtkdoc-scan executable
#   GTKDOC_SCANGOBJ_EXE     ... the location of the gtkdoc-scangobj executable
#   GTKDOC_MKDB_EXE         ... the location of the gtkdoc-mkdb executable
#   GTKDOC_MKHTML_EXE       ... the location of the gtkdoc-mkhtml executable
#   GTKDOC_FIXXREF_EXE      ... the location of the gtkdoc-fixxref executable

#=============================================================================
# Copyright 2009 Rich Wareham
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

# The UseGtkDoc.cmake module requires at least 1.9, because it doesn't use
# the deprecated `gtkdoc-mktmpl` tool. We will check if the version satisfies
# the user's specified dependencies later (with the
# find_package_handle_standard_args() command).
pkg_check_modules(GtkDoc REQUIRED gtk-doc>=1.9)

find_program(GTKDOC_SCAN_EXE gtkdoc-scan PATH "${GLIB_PREFIX}/bin")
find_program(GTKDOC_SCANGOBJ_EXE gtkdoc-scangobj PATH "${GLIB_PREFIX}/bin")

get_filename_component(_this_dir ${CMAKE_CURRENT_LIST_FILE} PATH)
find_file(GTKDOC_SCANGOBJ_WRAPPER GtkDocScanGObjWrapper.cmake PATH ${_this_dir})

find_program(GTKDOC_MKDB_EXE gtkdoc-mkdb PATH "${GLIB_PREFIX}/bin")
find_program(GTKDOC_MKHTML_EXE gtkdoc-mkhtml PATH "${GLIB_PREFIX}/bin")
find_program(GTKDOC_FIXXREF_EXE gtkdoc-fixxref PATH "${GLIB_PREFIX}/bin")

find_package_handle_standard_args(GtkDoc
    REQUIRED_VARS GTKDOC_SCAN_EXE GTKDOC_SCANGOBJ_EXE GTKDOC_SCANGOBJ_WRAPPER GTKDOC_MKDB_EXE GTKDOC_MKHTML_EXE GTKDOC_FIXXREF_EXE
    VERSION_VAR GtkDoc_VERSION)
