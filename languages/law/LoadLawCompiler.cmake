#if(${VERBOSE})
  logStatus("    ** Generate LawCompiler.dll")
#endif()

logStatus("LAW COMPILER OUTPUT PATH : ${OutputPath}")
logStatus("LAW COMPILER PROJECT_BINARY_DIR : ${PROJECT_BINARY_DIR}")
logStatus("LAW COMPILER ARCGEOSIM_BUILD_SYSTEM_PATH : ${ARCGEOSIM_BUILD_SYSTEM_PATH}")
logStatus("LAW COMPILER XBUILD : ${XBUILD} ARGS ${XBUILD_ARGS}")

	
add_custom_command(
  OUTPUT  ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/bin/Debug/net6/LawCompiler.dll
  COMMAND ${XBUILD} 
  ARGS    ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/LawCompiler.csproj ${XBUILD_ARGS} 
  DEPENDS ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/LawCompiler.csproj
  )
   
bundle(
  BUNDLE ${PROJECT_BINARY_DIR}/bin/LawCompiler.dll 
  EXE    ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/bin/Debug/net6/LawCompiler.dll
  )

add_custom_command(
  OUTPUT  ${PROJECT_BINARY_DIR}/share/law.xsd
  COMMAND ${CMAKE_COMMAND} -E 
  copy_if_different ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/Law.xsd ${PROJECT_BINARY_DIR}/share/law.xsd
  DEPENDS ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/Law.xsd
  )

file(GLOB ALL_FILES ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/bin/Debug/net6/LawCompiler*)
add_custom_target(copy_runtime_json_law ALL)
foreach(CurrentFile IN LISTS ALL_FILES)
    add_custom_command(
          TARGET copy_runtime_json_law PRE_BUILD
          COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CurrentFile} ${PROJECT_BINARY_DIR}/bin/)
endforeach()

# génération de LawCompiler conditionnelle au début
add_custom_target(
  law ALL DEPENDS 
  ${PROJECT_BINARY_DIR}/bin/LawCompiler.dll
  ${PROJECT_BINARY_DIR}/share/law.xsd
  )

# on crée une target pour pouvoir écrire 
# /> make LawCompiler
add_custom_target(dotnet_LawCompiler 
  COMMAND ${XBUILD} ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/LawCompiler.csproj ${XBUILD_ARGS}
  COMMENT "generate LawCompiler tools")

install(FILES ${PROJECT_BINARY_DIR}/bin/LawCompiler.dll DESTINATION bin)

# répertoire de sortie des law
file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/share/law)

# installation de la xsd des fichiers law
install(FILES ${PROJECT_BINARY_DIR}/share/law.xsd DESTINATION share)

set(LAWCOMPILER dotnet ${PROJECT_BINARY_DIR}/bin/LawCompiler.dll)
