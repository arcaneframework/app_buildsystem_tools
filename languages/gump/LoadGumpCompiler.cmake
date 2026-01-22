if(${VERBOSE})
  logStatus("    ** Generate GumpCompiler.dll")
endif()

if (NOT GUMP_BINARY_DIR)
    set(GUMP_BINARY_DIR ${PROJECT_BINARY_DIR})
endif ()
	
add_custom_command(
  OUTPUT  ${GUMP_BINARY_DIR}/share/gump.xsd
  COMMAND ${CMAKE_COMMAND} -E 
  copy_if_different ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/Gump.xsd ${GUMP_BINARY_DIR}/share/gump.xsd
  DEPENDS ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/Gump.xsd
  )

# generation de GumpCompiler conditionnelle au debut
if (NOT TARGET gump_init)
    add_custom_target(
        gump_init ALL DEPENDS
        ${GUMP_BINARY_DIR}/share/gump.xsd
    )
endif ()

file(MAKE_DIRECTORY ${GUMP_BINARY_DIR}/bin/GumpCompiler)

if (NOT TARGET gump_copy_binary)
    add_custom_target(gump_copy_binary ALL
        COMMAND ${CMAKE_COMMAND} -E copy_directory
	${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/bin/${DOTNET_BUILD_TYPE}/net${DOTNET_VERSION}/publish
        ${GUMP_BINARY_DIR}/bin/GumpCompiler
    )
endif ()

add_dependencies(gump_copy_binary gump_init)

if (NOT TARGET gump)
    add_custom_target(gump ALL)
endif ()

add_dependencies(gump gump_copy_binary)

# on cree une target pour pouvoir ecrire 
# /> make GumpCompiler
if (NOT TARGET dotnet_GumpCompiler)
    add_custom_target(dotnet_GumpCompiler
        COMMAND ${XBUILD} ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/GumpCompiler.csproj ${XBUILD_ARGS}
        COMMENT "generate GumpCompiler tools"
    )
endif ()

# repertoire de sortie des gump
file(MAKE_DIRECTORY ${GUMP_BINARY_DIR}/share/gump)

# installation de la xsd des fichiers gump
install(FILES ${GUMP_BINARY_DIR}/share/gump.xsd DESTINATION share)

set(GUMPCOMPILER dotnet ${GUMP_BINARY_DIR}/bin/GumpCompiler/GumpCompiler.dll)
