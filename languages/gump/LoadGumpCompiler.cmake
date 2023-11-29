#if(${VERBOSE})
  logStatus("    ** Generate GumpCompiler.dll")
#endif()

logStatus("GUMP COMPILER OUTPUT PATH : ${OutputPath}")
logStatus("GUMP COMPILER PROJECT_BINARY_DIR : ${PROJECT_BINARY_DIR}")
logStatus("GUMP COMPILER ARCGEOSIM_BUILD_SYSTEM_PATH : ${ARCGEOSIM_BUILD_SYSTEM_PATH}")
logStatus("GUMP COMPILER XBUILD : ${XBUILD} ARGS ${XBUILD_ARGS}")

	
add_custom_command(
  OUTPUT  ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/bin/Debug/net6/GumpCompiler.dll
  COMMAND ${XBUILD} 
  ARGS    ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/GumpCompiler.csproj ${XBUILD_ARGS} 
  DEPENDS ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/GumpCompiler.csproj
  )
   
bundle(
  BUNDLE ${PROJECT_BINARY_DIR}/bin/GumpCompiler.dll 
  EXE    ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/bin/Debug/net6/GumpCompiler.dll
  )

add_custom_command(
  OUTPUT  ${PROJECT_BINARY_DIR}/share/gump.xsd
  COMMAND ${CMAKE_COMMAND} -E 
  copy_if_different ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/Gump.xsd ${PROJECT_BINARY_DIR}/share/gump.xsd
  DEPENDS ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/Gump.xsd
  )

file(GLOB ALL_FILES ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/bin/Debug/net6/GumpCompiler*)
add_custom_target(copy_runtime_json_gump ALL)
foreach(CurrentFile IN LISTS ALL_FILES)
    add_custom_command(
          TARGET copy_runtime_json_gump PRE_BUILD
          COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CurrentFile} ${PROJECT_BINARY_DIR}/bin/)
endforeach()

# génération de GumpCompiler conditionnelle au début
add_custom_target(
  gump ALL DEPENDS 
  ${PROJECT_BINARY_DIR}/bin/GumpCompiler.dll
  ${PROJECT_BINARY_DIR}/share/gump.xsd
  )

# on crée une target pour pouvoir écrire 
# /> make GumpCompiler
add_custom_target(dotnet_GumpCompiler 
  COMMAND ${XBUILD} ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/GumpCompiler/GumpCompiler.csproj ${XBUILD_ARGS}
  COMMENT "generate GumpCompiler tools")

install(FILES ${PROJECT_BINARY_DIR}/bin/GumpCompiler.dll DESTINATION bin)

# répertoire de sortie des gump
file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/share/gump)

# installation de la xsd des fichiers gump
install(FILES ${PROJECT_BINARY_DIR}/share/gump.xsd DESTINATION share)

set(GUMPCOMPILER dotnet ${PROJECT_BINARY_DIR}/bin/GumpCompiler.dll)
