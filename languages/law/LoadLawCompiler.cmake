if(${VERBOSE})
  logStatus("    ** Generate LawCompiler.dll")
endif()

if (NOT LAW_BINARY_DIR)
    set(LAW_BINARY_DIR ${PROJECT_BINARY_DIR})
endif ()

add_custom_command(
  OUTPUT  ${LAW_BINARY_DIR}/share/law.xsd
  COMMAND ${CMAKE_COMMAND} -E 
  copy_if_different ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/Law.xsd ${LAW_BINARY_DIR}/share/law.xsd
  DEPENDS ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/Law.xsd
  )

# generation de LawCompiler conditionnelle au debut
if (NOT TARGET law_init)
    add_custom_target(
        law_init ALL DEPENDS
        ${LAW_BINARY_DIR}/share/law.xsd
    )
endif ()

file(MAKE_DIRECTORY ${LAW_BINARY_DIR}/bin/LawCompiler)

if (NOT TARGET law_copy_binary)
    add_custom_target(law_copy_binary ALL
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/bin/Debug/net6/publish
        ${LAW_BINARY_DIR}/bin/LawCompiler
    )
endif ()

add_dependencies(law_copy_binary law_init)

if (NOT TARGET law)
    add_custom_target(law ALL)
endif ()

add_dependencies(law law_copy_binary)

# on cree une target pour pouvoir ecrire 
# /> make LawCompiler
if (NOT TARGET dotnet_LawCompiler)
    add_custom_target(dotnet_LawCompiler
        COMMAND ${XBUILD} ${ARCGEOSIM_BUILD_SYSTEM_PATH}/csharp/LawCompiler/LawCompiler.csproj ${XBUILD_ARGS}
        COMMENT "generate LawCompiler tools")
endif ()

# repertoire de sortie des law
file(MAKE_DIRECTORY ${LAW_BINARY_DIR}/share/law)

# installation de la xsd des fichiers law
install(FILES ${LAW_BINARY_DIR}/share/law.xsd DESTINATION share)

set(LAWCOMPILER dotnet ${LAW_BINARY_DIR}/bin/LawCompiler/LawCompiler.dll)
