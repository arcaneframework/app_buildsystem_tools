# Find Neo::Neo target : only needed to copy dll. Must set NEO_LIBRARIES
if (WIN32)
    # Neo depends on SGraph (Header only library)
    find_package(SGraph REQUIRED)
    find_package(Neo REQUIRED)

    # set NEO_LIBRARIES
    if (CMAKE_BUILD_TYPE)
        string(TOUPPER "${CMAKE_BUILD_TYPE}" UPPER_BUILD_TYPE)
        get_target_property(NEO::NEO_LIBRARIES Neo::Neo IMPORTED_IMPLIB_${UPPER_BUILD_TYPE})
    else()
        get_target_property(NEO::NEO_LIBRARIES Neo::Neo IMPORTED_IMPLIB)
    endif()
endif ()