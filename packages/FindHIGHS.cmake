set(HIGHS_NAME "highs")

set(HIGHS_ROOT $ENV{HIGHS_ROOT})
message(status "FIND HIGHS : ${HIGHS_ROOT}")

if(HIGHS_ROOT)
  set(_HIGHS_SEARCH_OPTS NO_DEFAULT_PATH)
else()
  set(_HIGHS_SEARCH_OPTS)
endif()

find_path(HIGHS_INCLUDE_DIR Highs.h
	HINTS ${HIGHS_ROOT}
	PATH_SUFFIXES include/highs
	${_HIGHS_SEARCH_OPTS})
mark_as_advanced(HIGHS_INCLUDE_DIR)

find_library(HIGHS_LIBRARY highs
	HINTS ${HIGHS_ROOT}
	PATH_SUFFIXES lib
	${_HIGHS_SEARCH_OPTS})
mark_as_advanced(HIGHS_LIBRARY)

set(HIGHS_FIND_QUIETLY ON)

find_package_handle_standard_args(HIGHS
        DEFAULT_MSG
        HIGHS_INCLUDE_DIR
        HIGHS_LIBRARY)

if(HIGHS_FOUND AND NOT TARGET highs)
        set(HIGHS_INCLUDE_DIRS ${HIGHS_INCLUDE_DIR})
        set(HIGHS_LIBRARIES ${HIGHS_LIBRARY})
        #message(STATUS "HIGHS_LIBRARIES='${HIGHS_LIBRARIES}'")
        #message(STATUS "HIGHS_INCLUDE_DIRS='${HIGHS_INCLUDE_DIRS}'")
        add_library(highs UNKNOWN IMPORTED)
        set_target_properties(highs PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${HIGHS_INCLUDE_DIRS}")
        set_target_properties(highs PROPERTIES IMPORTED_LINK_INTERFACE_LANGUAGES "CXX" IMPORTED_LOCATION "${HIGHS_LIBRARIES}")
        add_definitions(-DUSE_HIGHS)
endif()

list(APPEND REQUIRED_DEPENDENCIES HIGHS)