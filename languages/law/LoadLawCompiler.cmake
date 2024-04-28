if(${VERBOSE})
  logStatus("    ** Generate LawCompiler.dll")
endif()
	
add_custom_command(
  OUTPUT  ${PROJECT_BINARY_DIR}/share/law.xsd
  COMMAND ${CMAKE_COMMAND} -E 
  copy_if_different ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/Law.xsd ${PROJECT_BINARY_DIR}/share/law.xsd
  DEPENDS ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/Law.xsd
  )

# generation de LawCompiler conditionnelle au debut
add_custom_target(
  law_init ALL DEPENDS 
  ${PROJECT_BINARY_DIR}/share/law.xsd
  )

file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/bin/LawCompiler)

add_custom_target(law_copy_binary ALL
  COMMAND ${CMAKE_COMMAND} -E copy_directory
  ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/bin/Debug/net6/publish
  ${PROJECT_BINARY_DIR}/bin/LawCompiler
 )

add_dependencies(law_copy_binary law_init)

add_custom_target(law ALL)

add_dependencies(law law_copy_binary)

# on cree une target pour pouvoir ecrire 
# /> make LawCompiler
add_custom_target(dotnet_LawCompiler 
  COMMAND ${XBUILD} ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/LawCompiler.csproj ${XBUILD_ARGS}
  COMMENT "generate LawCompiler tools")

# repertoire de sortie des law
file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/share/law)

# installation de la xsd des fichiers law
install(FILES ${PROJECT_BINARY_DIR}/share/law.xsd DESTINATION share)

set(LAWCOMPILER dotnet ${PROJECT_BINARY_DIR}/bin/LawCompiler/LawCompiler.dll)
