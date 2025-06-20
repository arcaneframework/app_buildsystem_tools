# packages
# --------

# Chargement des packages de ArcGeosim

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

loadPackage(NAME MPI   ESSENTIAL)
loadPackage(NAME Boost ESSENTIAL) 

# loadPackage(NAME MKL ESSENTIAL) 
# En fait pour cette dependance, en reecrivant a minima, 
# on veut juste les blas
loadPackage(NAME MKL)
if (NOT MKL_FOUND)
  loadPackage(NAME BLAS ESSENTIAL) 
endif (NOT MKL_FOUND)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# tools

loadPackage(NAME LibXml2) 
loadPackage(NAME Metis)
loadPackage(NAME Zoltan)
loadPackage(NAME HDF5) 
loadPackage(NAME HWLoc)
loadPackage(NAME TBB)
loadPackage(NAME HARTS)
loadPackage(NAME Numa)
loadPackage(NAME Cuda)
loadPackage(NAME NvAMG)
# a priori inutile car le finder IFPSolver 
# embarque les outils intel 
#loadPackage(NAME Intel)
loadPackage(NAME BinUtils)
loadPackage(NAME GeometryKernel)
loadPackage(NAME GPerfTools)
  
# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# solveurs

loadPackage(NAME Umfpack)
loadPackage(NAME PETSc) 
loadPackage(NAME Hypre) 
loadPackage(NAME MTL4) 
# A voir avec EasyBuild
loadPackage(NAME FFTW3) 
loadPackage(NAME SuperLU) 
loadPackage(NAME SuperLUDIST) 
loadPackage(NAME IFPSolver) 
loadPackage(NAME MCGSolver) 
loadPackage(NAME Eigen3) 
loadPackage(NAME Eigen2) 
loadPackage(NAME Umfpack) 
loadPackage(NAME GLPK)
loadPackage(NAME HIGHS)
loadPackage(NAME PreCICE)
loadPackage(NAME ONNX)
# Remarque
# en attendant version unique Carnot avec ECPA
# pour l instant la version Carnot ECPA et dans Geoxim
if(NOT DEFINED $ENV{CARNOT_ECPA})
loadPackage(NAME Carnot)
endif()
# Dependency for polyhedral mesh
loadPackage(NAME Neo ESSENTIAL)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# arcane

# NB: en avant-dernier car arcane charge eventuellement d'autres packages
#     si le package existe deja, on ne fait rien

loadPackage(NAME Arccore ESSENTIAL)
loadPackage(NAME Axlstar ESSENTIAL) 
loadPackage(NAME Arcane ESSENTIAL) 
if(TARGET arcane_full)
    if (NOT TARGET arcane)
        add_library(arcane INTERFACE IMPORTED)
    endif ()

    get_target_property(ARCANE_FULL_LIBRARIES arcane_full INTERFACE_LINK_LIBRARIES)

   set_target_properties(arcane PROPERTIES
       INTERFACE_LINK_LIBRARIES "${ARCANE_FULL_LIBRARIES}"
       INTERFACE_LINK_OPTIONS "-Wl,--no-as-needed"
   )

    set_target_properties(arcane PROPERTIES 
        INTERFACE_INCLUDE_DIRECTORIES "${Arcane_INCLUDE_DIRS}")

    target_compile_definitions(arcane INTERFACE USE_ARCANE_V3)     
else()
  message(status "TARGET ARCANE_FULL NOT FOUND")
endif()
# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# alien

# NB: en dernier car alien charge eventuellement d'autres packages
#     si le package existe deja, on ne fait rien
loadPackage(NAME Alien)

# arccon fix
if (TARGET arcconpkg_Hypre)
else()
  add_library(arcconpkg_Hypre UNKNOWN IMPORTED)
	  
  set_target_properties(arcconpkg_Hypre PROPERTIES 
	  INTERFACE_INCLUDE_DIRECTORIES "${HYPRE_INCLUDE_DIRS}")
     
	set_target_properties(arcconpkg_Hypre PROPERTIES
    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
    IMPORTED_LOCATION "${HYPRE_LIBRARY}")
endif()

if (TARGET arcconpkg_PETSc)
else()
  if(TARGET petsc)
    add_library(arcconpkg_PETSc INTERFACE IMPORTED)
    set_property(TARGET petsc APPEND PROPERTY
    INTERFACE_LINK_LIBRARIES "petsc_main")
  endif()
endif()

if (TARGET arcconpkg_SuperLU)
else()
  add_library(arcconpkg_SuperLU UNKNOWN IMPORTED)
  set_target_properties(arcconpkg_SuperLU PROPERTIES
      IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
      IMPORTED_LOCATION "${SUPERLU_LIBRARY}"
      IMPORTED_NO_SONAME ON)
endif()

if (TARGET arcconpkg_MTL4)
else()
  add_library(arcconpkg_MTL4 UNKNOWN IMPORTED)
endif()


if (TARGET arcconpkg_TBB)
else()
  add_library(arcconpkg_TBB UNKNOWN IMPORTED)
  
  set_target_properties(arcconpkg_TBB PROPERTIES 
    INTERFACE_INCLUDE_DIRECTORIES "${TBB_INCLUDE_DIRS}"
    INTERFACE_LINK_LIBRARIES "$<$<CONFIG:debug>:${TBB_LIBRARY_DEBUG}>$<$<CONFIG:release>:${TBB_LIBRARY_RELEASE}>")
    
  set_target_properties(arcconpkg_TBB PROPERTIES
    IMPORTED_CONFIGURATIONS RELEASE
    IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
    IMPORTED_LOCATION_RELEASE "${TBB_LIBRARY_RELEASE}")
    
  set_target_properties(arcconpkg_TBB PROPERTIES
    IMPORTED_CONFIGURATIONS DEBUG
    IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
    IMPORTED_LOCATION_DEBUG "${TBB_LIBRARY_DEBUG}")
endif()

if (TARGET arcconpkg_HDF5)
else()
  add_library(arcconpkg_HDF5 UNKNOWN IMPORTED)
          
  set_target_properties(arcconpkg_HDF5 PROPERTIES 
          INTERFACE_INCLUDE_DIRECTORIES "${HDF5_INCLUDE_DIRS}")
     
   set_target_properties(arcconpkg_HDF5 PROPERTIES
    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
    IMPORTED_LOCATION "${HDF5_LIBRARY}")
endif()

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# Les packages ont ete trouves (ou non)
# ArcGeoSim necessite pour certains une option USE_<package>
# on la genere ici ainsi les finders restent generiques

foreach(target harts petsc nvamg numa mcgsolver ifpsolver hypre eigen3 eigen2 gperftools)
  if(TARGET ${target})
    string(TOUPPER ${target} name)
    set_target_properties(${target} PROPERTIES
      INTERFACE_COMPILE_DEFINITIONS "USE_${name}")
  endif()
endforeach()

if(TARGET mtl)  
  set_target_properties(mtl PROPERTIES
    INTERFACE_COMPILE_DEFINITIONS "USE_MTL4")
endif()

if(TARGET geometrykernel)  
  set_target_properties(geometrykernel PROPERTIES
    INTERFACE_COMPILE_DEFINITIONS "USE_GK")
endif()

if(TARGET mkl)
  set_target_properties(mkl PROPERTIES
    INTERFACE_COMPILE_DEFINITIONS "USE_MKL")
endif()

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
