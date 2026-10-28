set(PRECICE_NAME "precice")


find_package(precice)
if(TARGET precice::precice)
  if(NOT TARGET precice)
    add_library(precice ALIAS precice::precice)
  endif()
  add_definitions(-DUSE_PRECICE)
  if(${precice_VERSION_MAJOR} EQUAL 3)
    add_definitions(-DUSE_PRECICE_V3)
  endif()
  return()
endif()
set(PRECICE_ROOT_DIR $ENV{PRECICE_ROOT})

find_path(PRECICE_INCLUDE_DIR precice/SolverInterface.hpp
  PATHS ${PRECICE_ROOT_DIR}/include NO_DEFAULT_PATH)
  
find_library(PRECICE_LIBRARY precice
  PATHS ${PRECICE_ROOT_DIR}/lib64 NO_DEFAULT_PATH)
  
set(PRECICE_FOUND "NO")
if(PRECICE_INCLUDE_DIR)
  if(NOT PRECICE_LIBRARY_FAILED)
    set(PRECICE_FOUND "YES" CACHE STRING "PRECICE found" FORCE)
    set(PRECICE_INCLUDE_DIRS ${PRECICE_INCLUDE_DIR})
    set(PRECICE_LIBRARIES ${PRECICE_LIBRARY})
    add_library(precice UNKNOWN IMPORTED)
    set_target_properties(precice PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${PRECICE_INCLUDE_DIRS}")
    set_target_properties(precice PROPERTIES IMPORTED_LINK_INTERFACE_LANGUAGES "CXX" IMPORTED_LOCATION "${PRECICE_LIBRARIES}")
    add_definitions(-DUSE_PRECICE)
  endif(NOT PRECICE_LIBRARY_FAILED)
endif(PRECICE_INCLUDE_DIR)

list(APPEND REQUIRED_DEPENDENCIES PRECICE)
