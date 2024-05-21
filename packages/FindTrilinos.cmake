#
# Find the TRILINOS includes and library
#
# This module uses
# TRILINOS_ROOT
#
# This module defines
# TRILINOS_FOUND
# TRILINOS_INCLUDE_DIRS
# TRILINOS_LIBRARIES
#

if (NOT TRILINOS_ROOT)
    set(TRILINOS_ROOT $ENV{TRILINOS_ROOT})
endif ()

if (TRILINOS_ROOT)
    set(_TRILINOS_SEARCH_OPTS NO_DEFAULT_PATH)
else ()
    set(_TRILINOS_SEARCH_OPTS)
endif ()

SET(Trilinos_PREFIX ${TRILINOS_ROOT})

SET(Trilinos_DIR ${TRILINOS_ROOT})

SET(CMAKE_PREFIX_PATH ${Trilinos_PREFIX} ${CMAKE_PREFIX_PATH})

find_package(Trilinos PATHS ${TRILINOS_ROOT} HINTS lib lib64)

# Echo trilinos build info just for fun
MESSAGE("\nFound Trilinos!  Here are the details: ")
MESSAGE("   Trilinos_DIR                    = ${Trilinos_DIR}")
MESSAGE("   Trilinos_VERSION                = ${Trilinos_VERSION}")
MESSAGE("   Trilinos_PACKAGE_LIST           = ${Trilinos_PACKAGE_LIST}")
MESSAGE("   Trilinos_PACKAGE_LIST           = ${Trilinos_ALL_PACKAGES_TARGETS}")
MESSAGE("   Trilinos_LIBRARIES              = ${Trilinos_LIBRARIES}")
MESSAGE("   Trilinos_INCLUDE_DIRS           = ${Trilinos_INCLUDE_DIRS}")
MESSAGE("   Trilinos_LIBRARY_DIRS           = ${Trilinos_LIBRARY_DIRS}")
MESSAGE("   Trilinos_TPL_LIST               = ${Trilinos_TPL_LIST}")
MESSAGE("   Trilinos_TPL_INCLUDE_DIRS       = ${Trilinos_TPL_INCLUDE_DIRS}")
MESSAGE("   Trilinos_TPL_LIBRARIES          = ${Trilinos_TPL_LIBRARIES}")
MESSAGE("   Trilinos_TPL_LIBRARY_DIRS       = ${Trilinos_TPL_LIBRARY_DIRS}")
MESSAGE("   Trilinos_BUILD_SHARED_LIBS      = ${Trilinos_BUILD_SHARED_LIBS}")
MESSAGE("   Trilinos_CXX_COMPILER_FLAGS     = ${Trilinos_CXX_COMPILER_FLAGS}")
MESSAGE("   Trilinos_C_COMPILER_FLAGS       = ${Trilinos_C_COMPILER_FLAGS}")
MESSAGE("   Trilinos_Fortran_COMPILER_FLAGS = ${Trilinos_Fortran_COMPILER_FLAGS}")
MESSAGE("End of Trilinos details\n")

# pour limiter le mode verbose
set(Trilinos_FIND_QUIETLY ON)

find_package_handle_standard_args(Trilinos
        DEFAULT_MSG
        Trilinos_INCLUDE_DIRS
        Trilinos_LIBRARIES)

if (Trilinos_FOUND AND NOT TARGET trilinos)

    set(TRILINOS_INCLUDE_DIRS ${Trilinos_INCLUDE_DIR})

    # TRILINOS
    add_library(trilinos INTERFACE IMPORTED)
    set_target_properties(trilinos PROPERTIES
                          INTERFACE_INCLUDE_DIRECTORIES "${Trilinos_INCLUDE_DIRS}")
    foreach (lib ${Trilinos_LIBRARIES})
        set_property(TARGET trilinos APPEND PROPERTY  INTERFACE_LINK_LIBRARIES "${lib}")
    endforeach()

    foreach (targ ${Trilinos_ALL_PACKAGES_TARGETS})
        add_dependencies(trilinos ${targ})
    endforeach()

endif ()
