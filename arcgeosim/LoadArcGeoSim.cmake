# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# chemin du fichier

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.7.1)

# pour VERSION dans la commande project
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0023 NEW)
cmake_policy(SET CMP0054 NEW)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

set(INFRA_BUILDSYSTEM_PATH ${PROJECT_SOURCE_DIR}/common/ArcaneInfra/build-system)
set(ARCGEOSIM_BUILD_SYSTEM_PATH ${PROJECT_SOURCE_DIR}/common/ArcaneInfra/build-system) 
list(APPEND CMAKE_MODULE_PATH ${INFRA_BUILDSYSTEM_PATH}/tools)
list(APPEND CMAKE_MODULE_PATH ${INFRA_BUILDSYSTEM_PATH})

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# Parametrage du systeme de compilation
# NB: a faire AVANT l'inclusion de LoadBuildSystem 

# Les libs/exe ne sont pas construits dans des repertoires de configuration (Debug/Release)
# NB: important pour les tests : pas de mise a jour de PATH necessaire pour la recherche de dlls
set(BUILDSYSTEM_NO_CONFIGURATION_OUTPUT_DIRECTORY ON)

# Repertoire d'exportation des dlls (pour windows)
# NB: important pour les tests : pas de mise a jour de PATH necessaire pour la recherche de dlls
set(BUILDSYSTEM_DLL_COPY_DIRECTORY ${PROJECT_BINARY_DIR}/bin)

# par defaut, on a que axl
if(NOT USE_LANGUAGE_GUMP)
  set(USE_LANGUAGE_GUMP OFF)
endif()

if(NOT USE_LANGUAGE_LAW)
  set(USE_LANGUAGE_LAW OFF)
endif()

# par defaut le package google tools est desactive sauf si on force le link
set(gperftools_IS_DISABLED ON)
set(gperftools_WHY "disabled by default (use -DEnablePackages=gperftools to activate it)")

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# parametrage par defaut

include(LoadBuildSystem)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# options arcgeosim
include(LoadArcGeoSimOptions)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# chargement du fichier de package arcgeosim
include(LoadOSFeatures)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# chargement du fichier de package arcgeosim
include(LoadArcGeoSimPackageFile)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# metas par defaut (win32/linux)
include(LoadDefaultMetas)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# options de compilation par defaut
include(LoadDefaultCompilationFlags) 

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# packages par defaut (mono et glib)
include(LoadDefaultPackages)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# configuration specifique de arcgeosim
include(LoadArcGeoSimConfiguration)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# langages (axl, gump, law, ...) NB: apres les packages
include(LoadArcGeoSimLanguages) 

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# packages de arcgeosim
include(LoadArcGeoSimPackages)

# ----------------------------------------------------------------------------
# --    Tmp for geoxim to delete when geoxim trunk with alien version 1.1  ---

if(ALIEN_VERSION EQUAL 1.0)
  loadMeta(NAME alien_v_1_0)
endif()

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# pour les tests
include(LoadArcGeoSimTestingTools)

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

enable_testing()

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
