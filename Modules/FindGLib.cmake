#.rst:
# FindGLib
# ----------
#
# CMake macros to find the GLib 2.x library and tools

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
