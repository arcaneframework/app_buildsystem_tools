# For Windows only : to copy Zoltan dll
# ZOLTAN_LIBRARIES must contain the complete name (path included) of Zoltan.lib

if (WIN32)
    find_package(Zoltan QUIET)
    if (Zoltan_FOUND)
        STRING(CONCAT ZOLTAN_LIBRARIES_FULLNAME ${Zoltan_LIBRARY_DIRS} "/" ${Zoltan_LIBRARIES} ".lib")
        set (ZOLTAN_LIBRARIES ${ZOLTAN_LIBRARIES_FULLNAME})
    endif ()
endif ()
