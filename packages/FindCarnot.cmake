#
# Find the CARNOT includes and library
#
# This module uses
# CARNOT_ROOT
#
# This module defines
# CARNOT_FOUND
# CARNOT_INCLUDE_DIRS
# CARNOT_LIBRARIES
#
# Target carnot

if(NOT CARNOT_ROOT)
  set(CARNOT_ROOT $ENV{CARNOT_ROOT})
endif()

set(CARNOT_INCLUDE_PATH ${CARNOT_ROOT}/include)
set(CARNOT_LIBRARY_PATH ${CARNOT_ROOT}/lib64)

if(CARNOT_ROOT)
  set(_CARNOT_SEARCH_OPTS NO_DEFAULT_PATH)
else()
  set(_CARNOT_SEARCH_OPTS)
endif()

if(NOT CARNOT_FOUND) 
 
  # Carnot library
  
  find_library(CARNOT_LIBRARY 
        NAMES carnot_interface
        PATHS ${CARNOT_LIBRARY_PATH} 
        ${_CARNOT_SEARCH_OPTS})
  mark_as_advanced(CARNOT_LIBRARY)
  
  # Carnot include interface cpp
    
  find_path(CARNOT_INCLUDE_DIR Interface.h
    PATHS ${CARNOT_INCLUDE_PATH}
    ${_CARNOT_SEARCH_OPTS}
    )
  mark_as_advanced(CARNOT_INCLUDE_DIR)
  
endif()

find_package_handle_standard_args(Carnot 
        DEFAULT_MSG 
        CARNOT_INCLUDE_DIR
        CARNOT_LIBRARY
        )
 
# pour limiter le mode verbose
set(CARNOT_FIND_QUIETLY ON)

if(CARNOT_FOUND AND NOT TARGET carnot)

  set(CARNOT_INCLUDE_DIRS ${CARNOT_INCLUDE_DIR})
  set(CARNOT_LIBRARIES ${CARNOT_LIBRARY})
  
  add_library(carnot SHARED IMPORTED)
  
  set_target_properties(carnot PROPERTIES 
    INTERFACE_INCLUDE_DIRECTORIES "${CARNOT_INCLUDE_DIRS}") 
    
  set_target_properties(carnot PROPERTIES
    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
    IMPORTED_LOCATION "${CARNOT_LIBRARIES}")
    
  add_definitions(-DUSE_CARNOT)

endif()
