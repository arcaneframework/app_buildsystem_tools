message_separator()

logStatus("Load configuration :")

# 1. On lit un eventuel fichier de package -DPackageFile=<...>
#    dans lequel une macro ARCANE_ROOT a peut etre ete definie 
#    Ecrase ARCANE_ROOT si l'utilisateur a ecrit -DARCANE_ROOT=<...> 
logStatus("PACKAGE FILE : ${PACKAGE_FILE}")
if(${PACKAGE_FILE})

  logStatus(" * Using package file '${PACKAGE_FILE_VALUE}'")
  
  # chargement du fichier de package
  include(LoadDefaultPackageFile)

endif()

if (NOT ARCANEFRAMEWORK_ROOT)
  if (DEFINED ENV{ARCANEFRAMEWORK_ROOT})
    set(ARCANEFRAMEWORK_ROOT $ENV{ARCANEFRAMEWORK_ROOT})
  endif ()
endif ()

if (ARCANEFRAMEWORK_ROOT)
  list (APPEND CMAKE_PREFIX_PATH ${ARCANEFRAMEWORK_ROOT})
  if(NOT PROJECT_IS_TOP_LEVEL)
   set (CMAKE_PREFIX_PATH PARENT_SCOPE)
  endif ()
  set(USE_ALIEN_V20 ON)
endif ()

set(Arccon_USE_CMAKE_CONFIG TRUE)
set(Arccore_USE_CMAKE_CONFIG TRUE)
set(Axlstar_USE_CMAKE_CONFIG TRUE)
set(Arcane_USE_CMAKE_CONFIG TRUE)
set(ALIEN_USE_CMAKE_CONFIG TRUE)

set(Hypre_USE_CMAKE_CONFIG TRUE)
set(MTL4_USE_CMAKE_CONFIG TRUE)
#set(SuperLU_USE_CMAKE_CONFIG TRUE)

# 2. On ecrase ARCANE_ROOT si un chemin est donne par l'utilisateur
#    en ligne de commande (-DArcanePath=<...>)

# Override using user path
if(${CUSTOM_ARCANE_PATH})

  set(ARCANE_ROOT 
    ${CUSTOM_ARCANE_PATH_VALUE}
    CACHE INTERNAL "Arcane root path")

endif()

# Maintenant on gere si ARCANE_ROOT non defini par 
# -DPackageFile=<...>, -DARCANE_ROOT=<...> ou -DArcanePath=<...>

# 3. Si ARCANE_ROOT n'est pas defini (pas dans packages, pas en ligne de commande)
#    On cherche dans l'environnement

if(NOT ARCANE_ROOT)
  
  set(ARCANE_ROOT $ENV{ARCANE_ROOT})
  
endif()

# Pour ALIEN, c'est la meme chose

# 1. ALIEN_ROOT a peut etre ete defini par -DPackageFile=<...> ou -DALIEN_ROOT=<...> 

# 2. On ecrase ALIEN_ROOT si un chemin est donne par l'utilisateur
#    en ligne de commande (-DAlienPath=<...>)

# Override using user path
if(${CUSTOM_ALIEN_PATH})

  set(ALIEN_ROOT 
    ${CUSTOM_ALIEN_PATH_VALUE}
    CACHE INTERNAL "Alien root path")

endif()

# 3. Si ALIEN_ROOT n'est pas defini (pas dans packages, pas en ligne de commande)
#    On cherche dans l'environnement

if(NOT ALIEN_ROOT)
  
  set(ALIEN_ROOT $ENV{ALIEN_ROOT})
  
endif()

# 4. Si ALIEN_ROOT n'est pas defini (pas dans packages, pas en ligne de commande, pas dans l'env)
#    On charge automatiquement ALIEN_ROOT par rapport à la toolchain 

if (USE_ALIEN_V20)
  if(AlienProd_DIR)
    logStatus(" * Using AlienProdConfig : ${AlienProd_DIR}/AlienProdConfig.cmake")
    set(ALIEN_DIR ${AlienProd_DIR})
  endif()
  if(AlienPlugins_DIR)
    logStatus(" * Using AlienPluginsConfig : ${AlienPlugins_DIR}/AlienPluginsConfig.cmake")
    set(ALIEN_DIR ${AlienPlugins_DIR})
  endif()
  set(ALIEN_USE_CMAKE_CONFIG FALSE)
else()
  if(NOT ALIEN_ROOT)
    # Version par defaut pour Alien 1.*
    if(NOT ALIEN_VERSION)
      logFatal("ALIEN_VERSION is not defined. Add it to your CMakeLists.txt and contact your administrator.")
    endif()

    # detection du numero de release centos/rhel
    if(${REDHAT_RELEASE} MATCHES "(CentOS|Red Hat Enterprise Linux).* release ([0-9]).*")
      set(rhel "RHEL${CMAKE_MATCH_2}")
    endif()

    # toolchain dans l'environnement
    set(toolchain $ENV{TOOLCHAIN})

    # si pas defini, on utilise le legacy gcc472
    if(toolchain)
      set(toolchain $ENV{TOOLCHAIN}-2018b)
    else()
      set(toolchain gcc472)
    endif()

    if(CMAKE_BUILD_TYPE STREQUAL "Release")
      set(mode ref)
    else()
      set(mode dbg)
    endif()

    if (DEFINED ENV{EXPL_INSTALL})
      set(ALIEN_ROOT
          $ENV{EXPL_INSTALL}/alien/${ALIEN_VERSION}/Linux/${rhel}/x86_64/${mode}-arcane-${toolchain}
          CACHE INTERNAL "Alien root path")
    else()
      set(ALIEN_ROOT
          /home/irsrvshare1/R11/arcuser/Alien/${ALIEN_VERSION}/Linux/${rhel}/x86_64/${mode}-arcane-${toolchain}
          CACHE INTERNAL "Alien root path")
    endif()

  endif()

  logStatus(" * Using Alien  path : ${ALIEN_ROOT}")

endif()
