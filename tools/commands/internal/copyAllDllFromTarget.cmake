function(copyAllDllFromTarget target)

  if(NOT TARGET ${target})
    logFatalError("target ${target} not defined")
  endif()

  string(REPLACE "arccon::" "" target_name ${target})

  set(target ${target_name})

  message(STATUS "copy dll for target ${target}")

  string(TOUPPER ${target} TARGET)

  # Handle Arcane libs with Arcane 3: this function wants a list of path prefixed libs while target only contains libs names (arcane_mpi...)
  if (${target} STREQUAL "Arcane::arcane_full")
    unset(${TARGET}_LIBRARIES)
    # Build Arcane library list for dll copy
    get_target_property(${target}_LIBRARIES ${target} INTERFACE_LINK_LIBRARIES)
    foreach (lib ${${target}_LIBRARIES})
      # change Arccane::arcane_lib (mpi, core, ...) into arcane_lib (mpi,core...)
      string(REPLACE "Arcane::" "" lib_name ${lib})
      # get full lib pat : install_path/arcane_lib
      find_library(${lib}_LIBRARIES ${lib_name} HINTS ${ARCANE_PREFIX_DIR}/lib)
      list(APPEND ${TARGET}_LIBRARIES ${${lib}_LIBRARIES})
    endforeach ()
    message(STATUS "Arcane libraries ${${TARGET}_LIBRARIES}")
  endif ()

  # Handle Arccore libs with Arcane 3: same manip than Arcane
  if (${target} STREQUAL "Arccore::arccore_full")
    unset(${TARGET}_LIBRARIES)
    # Build Arccore library list for dll copy
    get_target_property(${target}_LIBRARIES ${target} INTERFACE_LINK_LIBRARIES)
    foreach (lib ${${target}_LIBRARIES})
      string(REPLACE "Arccore::" "" lib_name ${lib})
      find_library(${lib}_LIBRARIES ${lib_name} HINTS ${ARCANE_PREFIX_DIR}/lib)
      list(APPEND ${TARGET}_LIBRARIES ${${lib}_LIBRARIES})
    endforeach ()
    message(STATUS "Arcane libraries ${${TARGET}_LIBRARIES}")
  endif ()

  foreach(lib ${${TARGET}_LIBRARIES})
    if(${lib} STREQUAL optimized)
      continue()
    endif()
    if(${lib} STREQUAL debug)
      continue()
    endif()
    get_filename_component(dll ${lib} NAME_WE)
    get_filename_component(path ${lib} PATH)
    if("${path}" STREQUAL "") # lib locale ? lib systeme ?
      continue()
    endif()
    file(GLOB dlls "${path}/*${dll}*.dll")
    get_filename_component(path ${path} PATH)
    if("${path}" STREQUAL "") # lib locale ? lib systeme ?
      continue()
    endif()
    file(GLOB lib_dlls "${path}/lib/*${dll}*.dll")
    file(GLOB bin_dlls "${path}/bin/*${dll}*.dll")
    list(APPEND dlls ${bin_dlls} ${lib_dlls})
    list(REMOVE_DUPLICATES dlls)
    foreach(dll ${dlls})
      copyOneDllFile(${dll})
    endforeach()
  endforeach()
  
endfunction()
