#
# Find the SUPERLUDIST includes and library
#
# This module uses
# SUPERLUDIST_ROOT
#
# This module defines
# SUPERLUDIST_FOUND
# SUPERLUDIST_INCLUDE_DIRS
# SUPERLUDIST_LIBRARIES
#
# Target superlu 

if(NOT SUPERLUDIST_ROOT)
  set(SUPERLUDIST_ROOT $ENV{SUPERLUDIST_ROOT})
endif()

if(NOT SUPERLUDIST_ROOT)
  set(SUPERLUDIST_ROOT $ENV{SUPERLU_DIST_ROOT})
endif()

if(SUPERLUDIST_ROOT)
  set(_SUPERLUDIST_SEARCH_OPTS NO_DEFAULT_PATH)
else()
  set(_SUPERLUDIST_SEARCH_OPTS)
endif()

if(NOT SUPERLUDIST_FOUND)

  find_library(SUPERLUDIST_LIBRARY
    NAMES superlu_dist_2.4 superlu_dist
    HINTS ${SUPERLUDIST_ROOT} 
    PATH_SUFFIXES lib
    ${_SUPERLUDIST_SEARCH_OPTS}
    )

  mark_as_advanced(SUPERLUDIST_LIBRARY)

  find_library(SUPERLUDIST_BLAS_LIBRARY
    NAMES blas
    HINTS ${SUPERLUDIST_ROOT}
    PATH_SUFFIXES lib
    ${_SUPERLU_DIST_SEARCH_OPTS}
  )

  mark_as_advanced(SUPERLUDIST_BLAS_LIBRARY)

  find_path(SUPERLUDIST_INCLUDE_DIR superlu_defs.h
    HINTS ${SUPERLUDIST_ROOT} 
    PATH_SUFFIXES include
    ${_SUPERLUDIST_SEARCH_OPTS}
    )
  mark_as_advanced(SUPERLUDIST_INCLUDE_DIR)
  
endif()

# pour limiter le mode verbose
set(SUPERLUDIST_FIND_QUIETLY ON)

find_package_handle_standard_args(SUPERLUDIST
  DEFAULT_MSG 
  SUPERLUDIST_INCLUDE_DIR
  SUPERLUDIST_LIBRARY
  )

find_package_handle_standard_args(SUPERLUDIST_BLAS
  DEFAULT_MSG
  SUPERLUDIST_BLAS_LIBRARY
  )

if(SUPERLUDIST_FOUND AND NOT TARGET superludist)

  set(SUPERLUDIST_INCLUDE_DIRS ${SUPERLUDIST_INCLUDE_DIR})
  
  set(SUPERLUDIST_LIBRARIES ${SUPERLUDIST_LIBRARY})

  add_library(superludist_main UNKNOWN IMPORTED)
  
  set_target_properties(superludist_main PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${SUPERLUDIST_INCLUDE_DIRS}")
    
  set_target_properties(superludist_main PROPERTIES
    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
    IMPORTED_LOCATION "${SUPERLUDIST_LIBRARY}")
  
  if(SUPERLUDIST_BLAS_FOUND)
   add_library(superludist_blas UNKNOWN IMPORTED)

   set_target_properties(superludist_blas PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION "${SUPERLUDIST_BLAS_LIBRARY}")

   list(APPEND SUPERLUDIST_LIBRARIES ${SUPERLUDIST_BLAS_LIBRARY})
  endif()

  # superludist
  add_library(superludist INTERFACE IMPORTED)

  set_property(TARGET superludist APPEND PROPERTY
               INTERFACE_LINK_LIBRARIES "superludist_main")

  set_property(TARGET superludist APPEND PROPERTY
               INTERFACE_INCLUDE_DIRECTORIES "${SUPERLUDIST_INCLUDE_DIRS}")

  if(SUPERLUDIST_BLAS_FOUND)

    set_property(TARGET superludist APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "superludist_blas")

  endif()
endif()

