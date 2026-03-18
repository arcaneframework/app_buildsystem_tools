#
# Find the MCGSOLVER includes and library
#
# This module uses
# MCGSOLVER_ROOT
#
# This module defines
# MCGSOLVER_FOUND
# MCGSOLVER_INCLUDE_DIRS
# MCGSOLVER_LIBRARIES
#
# Target mcgsolver

if(NOT MCGSOLVER_ROOT)
    set(MCGSOLVER_ROOT $ENV{MCGSOLVER_ROOT})
endif()

if(MCGSOLVER_ROOT)
    set(_MCGSOLVER_SEARCH_OPTS NO_DEFAULT_PATH)
else()
    set(_MCGSOLVER_SEARCH_OPTS)
endif()

if(NOT MCGSOLVER_FOUND)
    MESSAGE("MCGSOLVER_ROOT ${MCGSOLVER_ROOT}")

    find_library(MCGSOLVER_LIBRARY
            NAMES MCGSolver
            HINTS ${MCGSOLVER_ROOT}
            PATH_SUFFIXES lib
            ${_MCGSOLVER_SEARCH_OPTS}
    )
    mark_as_advanced(MCGSOLVER_LIBRARY)

    MESSAGE("MCGSOLVER_LIBRARY ${MCGSOLVER_LIBRARY}")

    find_path(MCGSOLVER_INCLUDE_DIR MCGSolver/MCGSolver.h
            HINTS ${MCGSOLVER_ROOT}
            PATH_SUFFIXES include
            ${_MCGSOLVER_SEARCH_OPTS}
    )
    mark_as_advanced(MCGSOLVER_INCLUDE_DIR)

endif()

# pour limiter le mode verbose
set(MCGSOLVER_FIND_QUIETLY OFF)

find_package_handle_standard_args(MCGSOLVER
        DEFAULT_MSG
        MCGSOLVER_INCLUDE_DIR
        MCGSOLVER_LIBRARY)

if(MCGSOLVER_FOUND AND NOT TARGET mcgsolver)

    set(MCGSOLVER_INCLUDE_DIRS ${MCGSOLVER_INCLUDE_DIR})

    set(MCGSOLVER_LIBRARIES ${MCGSOLVER_LIBRARY})

    # mcgsolver main
    add_library(mcgsolver_main UNKNOWN IMPORTED)

    set_target_properties(mcgsolver_main PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${MCGSOLVER_INCLUDE_DIRS}")

    set_target_properties(mcgsolver_main PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
            IMPORTED_LOCATION "${MCGSOLVER_LIBRARY}")

    # mcgsolver
    add_library(mcgsolver INTERFACE IMPORTED)

    set_property(TARGET mcgsolver APPEND PROPERTY
            INTERFACE_LINK_LIBRARIES "mcgsolver_main")

    set_target_properties(mcgsolver PROPERTIES
            INTERFACE_COMPILE_DEFINITIONS "${MCGSOLVER_FLAGS}")

    set_property(TARGET mcgsolver APPEND PROPERTY
            INTERFACE_LINK_LIBRARIES numa)

    if(${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 9)
    set_property(TARGET mcgsolver APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES stdc++fs)
    endif()

    file(READ ${MCGSOLVER_INCLUDE_DIR}/Common/mcgs_config.h MCGS_CONFIG_H)
    # check if MCGSolver uses CUDA
    if(${MCGS_CONFIG_H} MATCHES "#define ENABLE_CUDA")
        message(STATUS "MCGSolver uses CUDA")
        add_library(mcgsolver::cuda INTERFACE IMPORTED)
    endif()
endif()