#
# Find the ALIEN includes and library
#
# This module uses
# ALIEN_ROOT
#
# This module defines
# ALIEN_FOUND
# ALIEN_INCLUDE_DIRS
# ALIEN_LIBRARIES
#
# Target alien

if (NOT USE_ALIEN_V20)
    if (${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.13.1")
        cmake_policy(SET CMP0074 OLD)
    endif()
endif ()

if(USE_ALIEN_V0)

  message(STATUS "Found ALIEN V0 at common/ALIEN")

  add_definitions(-DUSE_ALIEN_V0)
  include_directories("common/ALIEN/src")  
  
  return()

endif()

if(NOT ALIEN_ROOT)
    if ($ENV{ALIEN_ROOT})
        set(ALIEN_ROOT $ENV{ALIEN_ROOT})
    endif()
endif()

if(NOT ALIEN_FOUND)

    if (NOT ALIEN_DIR AND NOT ARCANEFRAMEWORK_ROOT)
        if (ALIEN_ROOT)
            set(ALIEN_DIR ${ALIEN_ROOT}/lib/cmake)
            message(STATUS "Loading alien : ALIEN DIR is" ${ALIEN_DIR})
        else ()
            logFatalError("No Alien directory installed given. Give ALIEN_ROOT or ALIEN_DIR)")
        endif ()
    endif ()


  if (ARCANEFRAMEWORK_ROOT)
    find_package(Alien REQUIRED)
  endif ()
  if (${Arcane_VERSION} VERSION_LESS "3.12.7.0")
    find_package(ALIEN REQUIRED)
  else ()
    find_package(AlienPlugins REQUIRED)
  endif ()

endif()

if(ALIEN_FOUND OR AlienPlugins_FOUND)

  if(USE_ALIEN_V20)
  message(STATUS "Found ALIEN V20 at common/ALIEN")
  endif()
  if(USE_ALIEN_V12)
  message(STATUS "Found ALIEN V12 at common/ALIEN")
  endif()

  string(TOUPPER ${CMAKE_BUILD_TYPE} type)


  if(USE_ALIEN_V20)

      get_target_property(ALIEN_CORE_LIBRARY Alien::alien_core IMPORTED_LOCATION_${type})
      get_target_property(ALIEN_REFSEMANTIC_LIBRARY Alien::alien_semantic_ref IMPORTED_LOCATION_${type})
      get_target_property(ALIEN_EXTERNALPACKAGES_LIBRARY alien_external_packages IMPORTED_LOCATION_${type})
      get_target_property(ALIEN_IFPEN_LIBRARY alien_ifpen_solvers IMPORTED_LOCATION_${type})
      if(TARGET alien_trilinos)
          get_target_property(ALIEN_TRILINOS_LIBRARY alien_trilinos IMPORTED_LOCATION_${type})
      endif()
      if(TARGET alien_hpddm)
          get_target_property(ALIEN_HPDDM_LIBRARY alien_hpddm IMPORTED_LOCATION_${type})
      endif()
      get_target_property(ALIEN_ARCANETOOLS_LIBRARY alien_arcane_tools IMPORTED_LOCATION_${type})
  else()
      get_target_property(ALIEN_INCLUDE_DIRS ALIEN INTERFACE_INCLUDE_DIRECTORIES)
      get_target_property(ALIEN_LIBRARY ALIEN IMPORTED_LOCATION_${type})
      if(USE_ALIEN_V12)
          get_target_property(ALIEN_IFPEN_LIBRARY ALIEN-IFPENSolvers IMPORTED_LOCATION_${type})
          get_target_property(ALIEN_TRILINOS_LIBRARY ALIEN-Trilinos IMPORTED_LOCATION_${type})
          get_target_property(ALIEN_HPDDM_LIBRARY ALIEN-HPDDM IMPORTED_LOCATION_${type})
          get_target_property(ALIEN_REFSEMANTIC_LIBRARY ALIEN-RefSemanticMVHandlers IMPORTED_LOCATION_${type})
          get_target_property(ALIEN_ARCANETOOLS_LIBRARY ALIEN-ArcaneTools IMPORTED_LOCATION_${type})
      else()
          get_target_property(ALIEN_IFPEN_LIBRARY ALIEN-IFPEN IMPORTED_LOCATION_${type})
          get_target_property(ALIEN_EXTERNALS_LIBRARY ALIEN-Externals IMPORTED_LOCATION_${type})
      endif()
      get_target_property(ALIEN_EXTERNALPACKAGES_LIBRARY ALIEN-ExternalPackages IMPORTED_LOCATION_${type})
  endif()

  if(USE_ALIEN_V20)
      set(ALIEN_LIBRARIES ${ALIEN_CORE_LIBRARY}
                          ${ALIEN_REFSEMANTIC_LIBRARY}
                          ${ALIEN_ARCANETOOLS_LIBRARY}
                          ${ALIEN_IFPEN_LIBRARY}
                          ${ALIEN_TRILINOS_LIBRARY}
                          ${ALIEN_HPDDM_LIBRARY}
                          ${ALIEN_EXTERNALPACKAGES_LIBRARY})
  else()
      if(USE_ALIEN_V12)
      set(ALIEN_LIBRARIES ${ALIEN_LIBRARY}
                          ${ALIEN_REFSEMANTIC_LIBRARY}
                          ${ALIEN_ARCANETOOLS_LIBRARY}
                          ${ALIEN_IFPEN_LIBRARY}
                          ${ALIEN_TRILINOS_LIBRARY}
                          ${ALIEN_HPDDM_LIBRARY}
                          ${ALIEN_EXTERNALPACKAGES_LIBRARY})
    
      else()
      set(ALIEN_LIBRARIES ${ALIEN_LIBRARY}
                          ${ALIEN_IFPEN_LIBRARY}
                          ${ALIEN_EXTERNALS_LIBRARY}
                          ${ALIEN_EXTERNALPACKAGES_LIBRARY})
      endif()
  endif()
  add_library(alien INTERFACE IMPORTED)
  
  if(USE_ALIEN_V20)
    set_property(TARGET alien APPEND PROPERTY 
      INTERFACE_LINK_LIBRARIES "Alien::alien_core")
    
    set_property(TARGET alien APPEND PROPERTY 
      INTERFACE_LINK_LIBRARIES "Alien::alien_semantic_ref")
  
    set_property(TARGET alien APPEND PROPERTY 
        INTERFACE_LINK_LIBRARIES "alien_external_packages")

		set_property(TARGET alien APPEND PROPERTY 
      INTERFACE_LINK_LIBRARIES "alien_ifpen_solvers")

    if(TARGET alien_trilinos)
      set_property(TARGET alien APPEND PROPERTY 
        INTERFACE_LINK_LIBRARIES "alien_trilinos")
    endif()

    if(TARGET alien_hpddm)
      set_property(TARGET alien APPEND PROPERTY 
        INTERFACE_LINK_LIBRARIES "alien_hpddm")
    endif()
    set_property(TARGET alien APPEND PROPERTY 
      INTERFACE_LINK_LIBRARIES "alien_arcane_tools")
  else()
    set_property(TARGET alien APPEND PROPERTY 
      INTERFACE_LINK_LIBRARIES "ALIEN")

    if(USE_ALIEN_V12)
      set_property(TARGET alien APPEND PROPERTY 
        INTERFACE_LINK_LIBRARIES "ALIEN-RefSemanticMVHandlers")

      set_property(TARGET alien APPEND PROPERTY 
        INTERFACE_LINK_LIBRARIES "ALIEN-IFPENSolvers")
    
      set_property(TARGET alien APPEND PROPERTY 
        INTERFACE_LINK_LIBRARIES "ALIEN-Trilinos")
    
      set_property(TARGET alien APPEND PROPERTY 
        INTERFACE_LINK_LIBRARIES "ALIEN-HPDDM")
    
      set_property(TARGET alien APPEND PROPERTY 
        INTERFACE_LINK_LIBRARIES "ALIEN-ArcaneTools")
    else()
      set_property(TARGET alien APPEND PROPERTY 
        INTERFACE_LINK_LIBRARIES "ALIEN-IFPEN")

      set_property(TARGET alien APPEND PROPERTY 
        INTERFACE_LINK_LIBRARIES "ALIEN-Externals")
    endif()

    set_property(TARGET alien APPEND PROPERTY 
      INTERFACE_LINK_LIBRARIES "ALIEN-ExternalPackages")
  endif()

  # Only for vs15 2017
  if(MSVC_VERSION GREATER 1900)
      if(TARGET hypre)
        get_target_property(HYPRE_LIBRARY hypre IMPORTED_LOCATION)
        get_filename_component(HYPRE_DIR ${HYPRE_LIBRARY} DIRECTORY)
        set(HYPRE_DLL_DIR "${HYPRE_DIR}")
        set(EXTRA_DLLS_TO_COPY 
           ${EXTRA_DLLS_TO_COPY}
           ${HYPRE_DLL_DIR}/hypre.dll)
      endif()
      if(TARGET petsc)
        get_target_property(PETSC_LIBRARY petsc_main IMPORTED_LOCATION)
        get_filename_component(PETSC_DIR ${PETSC_LIBRARY} DIRECTORY)
        set(PETSC_DLL_DIR "${PETSC_DIR}")
        # We need to add superlu, superlu_dist and its dependency
         set(EXTRA_DLLS_TO_COPY 
           ${EXTRA_DLLS_TO_COPY}
           //irfich3/R11-Group/Rt40_50_prj/D/D1653_Arcane/Public/Windows64/Softs/superlu/5.2.1-vs15/${CMAKE_BUILD_TYPE}/lib/libsuperlu_5.2.dll
           //irfich3/R11-Group/Rt40_50_prj/D/D1653_Arcane/Public/Windows64/Softs/superlu_dist/5.4.0-vs15/${CMAKE_BUILD_TYPE}/lib/superlu_dist.dll
           //irfich3/R11-Group/Rt40_50_prj/D/D1653_Arcane/Public/Windows64/Softs/superlu_dist/5.4.0-vs15/${CMAKE_BUILD_TYPE}/lib/blas.dll
           ${PETSC_DLL_DIR}/libpetsc.dll)
      endif()
      if(TARGET ifpsolver_main)
        get_target_property(IFPSOLVER_LIBRARY ifpsolver_main IMPORTED_LOCATION)
        get_target_property(IFPSOLVER_DOMAINDECOMP_LIBRARY ifpsolver_domaindecomp IMPORTED_LOCATION)
        # We need to add ifpsolver_decomp
         set(EXTRA_DLLS_TO_COPY 
           ${EXTRA_DLLS_TO_COPY}
           ${IFPSOLVER_LIBRARY}
           ${IFPSOLVER_DOMAINDECOMP_LIBRARY})
      endif()
  endif()
  if(USE_ALIEN_V20)
    add_definitions(-DUSE_ALIEN_V2)
    add_definitions(-DUSE_ALIEN_V20)
  else()
    add_definitions(-DUSE_ALIEN_V1)
    if(USE_ALIEN_V12)
      add_definitions(-DUSE_ALIEN_V12)
    endif()
  endif()

  set(Alien_PREFIX ${ALIEN_ROOT} CACHE INTERNAL "Alien prefix")
else()
  
  add_definitions(-DUSE_ALIEN_ARCGEOSIM)

endif()
