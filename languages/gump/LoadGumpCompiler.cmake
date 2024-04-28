if(${VERBOSE})
  logStatus("    ** Generate GumpCompiler.dll")
endif()
	
add_custom_command(
  OUTPUT  ${PROJECT_BINARY_DIR}/share/gump.xsd
  COMMAND ${CMAKE_COMMAND} -E 
  copy_if_different ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/Gump.xsd ${PROJECT_BINARY_DIR}/share/gump.xsd
  DEPENDS ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/Gump.xsd
  )

# generation de GumpCompiler conditionnelle au debut
add_custom_target(
  gump_init ALL DEPENDS 
  ${PROJECT_BINARY_DIR}/share/gump.xsd
  )

file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/bin/GumpCompiler)

add_custom_target(gump_copy_binary ALL
  COMMAND ${CMAKE_COMMAND} -E copy_directory
  ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/bin/Debug/net6/publish
  ${PROJECT_BINARY_DIR}/bin/GumpCompiler
 )

add_dependencies(gump_copy_binary gump_init)

add_custom_target(gump ALL)

add_dependencies(gump gump_copy_binary)

# on cree une target pour pouvoir ecrire 
# /> make GumpCompiler
add_custom_target(dotnet_GumpCompiler 
  COMMAND ${XBUILD} ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/GumpCompiler.csproj ${XBUILD_ARGS}
  COMMENT "generate GumpCompiler tools")

# repertoire de sortie des gump
file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/share/gump)

# installation de la xsd des fichiers gump
install(FILES ${PROJECT_BINARY_DIR}/share/gump.xsd DESTINATION share)

set(GUMPCOMPILER dotnet ${PROJECT_BINARY_DIR}/bin/GumpCompiler/GumpCompiler.dll)
