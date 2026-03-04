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
# Target superludist 

if(NOT SUPERLU_DIST_ROOT)
  set(SUPERLU_DIST_ROOT $ENV{SUPERLU_DIST_ROOT})
endif()

if(SUPERLU_DIST_ROOT)
  set(_SUPERLU_DIST_SEARCH_OPTS NO_DEFAULT_PATH)
else()
  set(_SUPERLU_DIST_SEARCH_OPTS)
endif()

if(NOT SUPERLU_DIST_FOUND)

  find_library(SUPERLU_DIST_LIBRARY
    NAMES superlu_dist
    HINTS ${SUPERLU_DIST_ROOT} 
    PATH_SUFFIXES lib
    ${_SUPERLU_DIST_SEARCH_OPTS}
    )
  mark_as_advanced(SUPERLU_DIST_LIBRARY)

  find_library(SUPERLU_DIST_BLAS_LIBRARY
    NAMES blas
    HINTS ${SUPERLU_DIST_ROOT}
    PATH_SUFFIXES lib
    ${_SUPERLU_DIST_SEARCH_OPTS}
  )
  mark_as_advanced(SUPERLU_DIST_BLAS_LIBRARY)

  find_path(SUPERLU_DIST_INCLUDE_DIR superlu_defs.h
    HINTS ${SUPERLU_DIST_ROOT} 
    PATH_SUFFIXES include
    ${_SUPERLU_DIST_SEARCH_OPTS}
    )
  mark_as_advanced(SUPERLU_DIST_INCLUDE_DIR)
  
endif()

# pour limiter le mode verbose
set(SUPERLU_DIST_FIND_QUIETLY ON)

find_package_handle_standard_args(SUPERLU_DIST
  DEFAULT_MSG 
  SUPERLU_DIST_INCLUDE_DIR
  SUPERLU_DIST_LIBRARY
  )

find_package_handle_standard_args(SUPERLU_DIST_BLAS
  DEFAULT_MSG
  SUPERLUDIST_BLAS_LIBRARY
  )

if(SUPERLU_DIST_FOUND AND NOT TARGET superludist)

  set(SUPERLU_DIST_INCLUDE_DIRS ${SUPERLU_DIST_INCLUDE_DIR})
  
  set(SUPERLU_DIST_LIBRARIES ${SUPERLU_DIST_LIBRARY})

  add_library(superludist_main UNKNOWN IMPORTED)
  set_target_properties(superludist_main PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${SUPERLU_DIST_INCLUDE_DIRS}")

  set_target_properties(superludist_main PROPERTIES
    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
    IMPORTED_LOCATION "${SUPERLU_DIST_LIBRARY}")

  if(SUPERLU_DIST_BLAS_FOUND)
   add_library(superludist_blas UNKNOWN IMPORTED)

   set_target_properties(superludist_blas PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION "${SUPERLU_DIST_BLAS_LIBRARY}")

  list(APPEND SUPERLU_DIST_LIBRARIES ${SUPERLU_DIST_BLAS_LIBRARY})
  endif()


    # superludist
  add_library(superludist INTERFACE IMPORTED)

  set_property(TARGET superludist APPEND PROPERTY
               INTERFACE_LINK_LIBRARIES "superludist_main")
  
  set_property(TARGET superludist APPEND PROPERTY
    INTERFACE_INCLUDE_DIRECTORIES "${SUPERLU_DIST_INCLUDE_DIRS}")
    
  if(SUPERLU_DIST_BLAS_FOUND)

    set_property(TARGET superludist APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "superludist_blas")

  endif()
  
endif()

