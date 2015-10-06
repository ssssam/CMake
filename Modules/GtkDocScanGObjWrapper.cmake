# Internal -- for use with UseGtkDoc.cmake
#
#=============================================================================
# Copyright 2009 Rich Wareham
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

if(NOT APPLE)
    # We use pkg-config to fing glib et al
    find_package(PkgConfig)
    # Find glib et al
    pkg_check_modules(GLIB REQUIRED glib-2.0 gobject-2.0)

foreach(_flag ${EXTRA_CFLAGS} ${GLIB_CFLAGS})
    set(ENV{CFLAGS} "$ENV{CFLAGS} \"${_flag}\"")
endforeach(_flag)

foreach(_flag ${EXTRA_LDFLAGS} ${GLIB_LDFLAGS})
    set(ENV{LDFLAGS} "$ENV{LDFLAGS} \"${_flag}\"")
endforeach(_flag)

foreach(_flag ${EXTRA_LDPATH})
    if(ENV{LD_LIBRARY_PATH})
        set(ENV{LD_LIBRARY_PATH} "$ENV{LD_LIBRARY_PATH}:\"${_flag}\"")
    else(ENV{LD_LIBRARY_PATH})
        set(ENV{LD_LIBRARY_PATH} "${_flag}")
    endif(ENV{LD_LIBRARY_PATH})
endforeach(_flag)

message(STATUS "Executing gtkdoc-scangobj with:")
message(STATUS "   CFLAGS: $ENV{CFLAGS}")
message(STATUS "  LDFLAGS: $ENV{LDFLAGS}")
message(STATUS "   LDPATH: $ENV{LD_LIBRARY_PATH}")

execute_process(COMMAND ${GTKDOC_SCANGOBJ_EXE}
    "--module=${doc_prefix}"
    "--types=${output_types}"
    "--output-dir=${output_dir}"
    WORKING_DIRECTORY "${output_dir}"
    RESULT_VARIABLE _scan_result)

if(_scan_result EQUAL 0)
    message(STATUS "Scan succeeded.")
else(_scan_result EQUAL 0)
    message(SEND_ERROR "Scan failed.")
endif(_scan_result EQUAL 0)

endif(NOT APPLE)

# vim:sw=4:ts=4:et:autoindent
