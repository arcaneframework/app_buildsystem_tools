#
# Find the DotNet package
#

if(WIN32)
  
  # Regarde le framework disponible
  # Toutes les versions du framework peuvent �tre disponibles mais
  # la version install�e par d�faut d�pend de la version de Windows:
  # - Windows 8 et 8.1 : v4.0
  # - Windows 7 : v3.5
  # On ne supporte pas les versions de windows plus anciennes.
  
  set(DOTNET_FRAMEWORK_ROOT $ENV{WinDir}/Microsoft.NET/Framework)
  
  if(EXISTS ${DOTNET_FRAMEWORK_ROOT}/v4.0.30319/msbuild.exe)
    set(DOTNET_FRAMEWORK_VERSION v4.0.30319)
  else()
    if(EXISTS ${DOTNET_FRAMEWORK_ROOT}/v3.5/msbuild.exe)
      set(DOTNET_FRAMEWORK_VERSION v3.5)
    endif()
  endif()
  
  set(DOTNET_FRAMEWORK_PATH ${DOTNET_FRAMEWORK_ROOT}/${DOTNET_FRAMEWORK_VERSION})
  
  if(NOT DOTNET_FRAMEWORK_VERSION)
    logFatalError("Can not find a valid installed Microsoft.NET framework")
  elseif(VERBOSE)
    logStatus("Found .NET Framework ${DOTNET_FRAMEWORK_PATH}")
  endif()
  
  find_program(CSC 
    NAMES csc
    HINTS ${DOTNET_FRAMEWORK_PATH}
	  NO_DEFAULT_PATH)
 
  # pour limiter le mode verbose
  set(DotNet_CSC_FIND_QUIETLY ON)

  find_package_handle_standard_args(DotNet_CSC 
	  DEFAULT_MSG
	  CSC)

  find_program(XBUILD 
    NAMES msbuild
    HINTS ${DOTNET_FRAMEWORK_PATH}
	  NO_DEFAULT_PATH)
  
  # pour limiter le mode verbose
  set(DotNet_XBUILD_FIND_QUIETLY ON)

  find_package_handle_standard_args(DotNet_XBUILD
	  DEFAULT_MSG 
	  XBUILD)
  
  if(DOTNET_CSC_FOUND AND DOTNET_XBUILD_FOUND)
    set(DOTNET_FOUND ON)
  endif()
  
else()
  find_program(XBUILD
               NAMES dotnet)

  set(DOTNET_FIND_QUIETLY ON)

  find_package_handle_standard_args(DOTNET
	  DEFAULT_MSG
	  XBUILD)

  set(XBUILD dotnet publish)

endif()

