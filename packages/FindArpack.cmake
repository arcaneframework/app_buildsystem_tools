#
# Find Arpack includes
#
# This module defines
# ARPACK_INCLUDE_DIRS, where to find headers,
# ARPACK_LIBRARIES, the libraries to link against to use boost.
# ARPACK_FOUND If false, do not try to use boost.

if(NOT ARPACK_ROOT)
  set(ARPACK_ROOT $ENV{ARPACK_ROOT})
endif()

if(NOT ARPACK_FOUND) 
  #Arpack
  find_library(ARPACK_LIBRARY
               NAMES arpack
               HINTS ${ARPACK_ROOT} 
               PATH_SUFFIXES lib
              )
  mark_as_advanced(ARPACK_LIBRARY)

endif()

find_package_handle_standard_args(Arpack 
        DEFAULT_MSG 
        ARPACK_LIBRARY
        )
 
# pour limiter le mode verbose
set(ARPACK_FIND_QUIETLY ON)

if(ARPACK_FOUND AND NOT TARGET arpack)

  #Construction de Arpack
  add_library(arpack UNKNOWN IMPORTED)
  set_target_properties(arpack PROPERTIES
                       IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                       IMPORTED_LOCATION "${ARPACK_LIBRARY}")
endif()

