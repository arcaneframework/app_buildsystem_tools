function(copyOneDllFile dll)

  get_filename_component(name ${dll} NAME)
  
  set(dll_copy ${BUILDSYSTEM_DLL_COPY_DIRECTORY}/${name})

  logStatus("Copying dll ${dll} into ${dll_copy}")

  if(MSVC_TOOLSET_VERSION GREATER_EQUAL 143)
    get_property(already_copied_dlls GLOBAL PROPERTY ${PROJECT_NAME}_DLLS_TO_COPY)
    if(NOT TARGET already_copied_${name})
      add_custom_command(
	OUTPUT ${dll_copy}
	COMMAND ${CMAKE_COMMAND} -E copy_if_different ${dll} ${dll_copy}
      )

      set_property(GLOBAL APPEND PROPERTY ${PROJECT_NAME}_DLLS_TO_COPY ${dll_copy})
      add_custom_target(already_copied_${name})
    endif()
  else()
    add_custom_command(
      OUTPUT ${dll_copy}
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${dll} ${dll_copy}
    )
    set_property(GLOBAL APPEND PROPERTY ${PROJECT_NAME}_DLLS_TO_COPY ${dll_copy})
  endif()
endfunction()
