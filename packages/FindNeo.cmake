# Find Neo::Neo target : only needed to copy dll. Must set NEO_LIBRARIES

# Neo depends on SGraph (Header only library)
find_package(SGraph REQUIRED)
find_package(Neo REQUIRED)

# set NEO_LIBRARIES
get_target_property(NEO_IMPORTED_CONFIGURATION Neo::Neo IMPORTED_CONFIGURATIONS)
get_target_property(NEO::NEO_LIBRARIES Neo::Neo IMPORTED_IMPLIB_${NEO_IMPORTED_CONFIGURATION})