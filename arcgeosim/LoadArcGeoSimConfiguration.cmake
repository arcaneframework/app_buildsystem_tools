message_separator()

logStatus("Load ArcGeoSim project configuration (defines, includes, etc.)")

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

if(USE_CXX11)
  add_definitions(-DARCGEOSIM_USE_CXX11)
else()
  logFatalError("ArcGeoSim needs C++11 standard")
endif()
add_definitions(-DARCGEOSIM_USE_EXPORT)
add_definitions(-DMPICH_IGNORE_CXX_SEEK -DMPICH_SKIP_MPICXX)

if(WIN32)
  # tous les symboles exportes sous windows
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
  add_compile_options(/bigobj)
  # strange required dll for VS22 in release
  if(DEFINED VCPKG_INSTALLED_DIR)
    set(ARCENV_VCPKG_INSTALLED_DIR_DEBUG ${VCPKG_INSTALLED_DIR}/x64-windows/debug/bin CACHE INTERNAL "VCPKG Debug install path")
    set(EXTRA_DLLS_TO_COPY 
	${EXTRA_DLLS_TO_COPY}
	${ARCENV_VCPKG_INSTALLED_DIR_DEBUG}/zlibd1.dll
	${ARCENV_VCPKG_INSTALLED_DIR_DEBUG}/pcred.dll
    )
  endif()
endif()

# includes pour simplifier
# for git framework only
include_directories(${PROJECT_BINARY_DIR})
# for git framework and ShArc or svn archi
include_directories(${ARCGEOSIM_FRAMEWORK_ROOT}/ArcGeoPhy/src)
include_directories(${ARCGEOSIM_FRAMEWORK_ROOT}/ArcGeoSim/src)
include_directories(${ARCGEOSIM_FRAMEWORK_ROOT}/ArcGeoSimR/src)
include_directories(${ARCGEOSIM_FRAMEWORK_ROOT}/SharedUtils/src)
include_directories(${ARCGEOSIM_FRAMEWORK_ROOT}/ArximCpp/src)
# for ShArc and svn archi only
include_directories(${ARCGEOSIM_FRAMEWORK_BINARY_DIR}/ArcGeoPhy/src)
include_directories(${ARCGEOSIM_FRAMEWORK_BINARY_DIR}/ArcGeoSim/src)
include_directories(${ARCGEOSIM_FRAMEWORK_BINARY_DIR}/SharedUtils/src)
include_directories(${ARCGEOSIM_FRAMEWORK_BINARY_DIR}/ArximCpp/src)
# for Appli (e.g. Geoxim)
include_directories(${PROJECT_BINARY_DIR}/src)
include_directories(${PROJECT_SOURCE_DIR}/src)
# to access to generated acgeosim_version.h
include_directories(${CMAKE_BINARY_DIR})
# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
