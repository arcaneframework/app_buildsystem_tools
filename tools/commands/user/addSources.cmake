function(addSources target)

  # commit ?
  get_target_property(committed ${target} BUILDSYSTEM_COMMITTED)

  if(${committed})
    logFatalError("target ${target} is alreday committed, can't add sources")
  endif()

  foreach(source ${ARGN})
    if(IS_ABSOLUTE ${source})
      set(file ${source})
    else()
      set(file ${CMAKE_CURRENT_LIST_DIR}/${source})
    endif()
    if(NOT EXISTS ${file})
      logFatalError("Source file ${file} doesn't exist")
    endif()
    list(APPEND sources ${file})
  endforeach()

  # ajout des sources
  set_property(TARGET ${target} APPEND PROPERTY BUILDSYSTEM_SOURCES ${sources})

endfunction()

function(addSYCLSources target)

  # commit ?
  get_target_property(committed ${target} BUILDSYSTEM_COMMITTED)

  if(${committed})
    logFatalError("target ${target} is alreday committed, can't add sources")
  endif()

  foreach(source ${ARGN})
    if(IS_ABSOLUTE ${source})
      set(file ${source})
    else()
      set(file ${CMAKE_CURRENT_LIST_DIR}/${source})
    endif()
    if(NOT EXISTS ${file})
      logFatalError("Source file ${file} doesn't exist")
    endif()
    list(APPEND sources ${file})
  endforeach()

  # ajout des sources
  set_property(TARGET ${target} APPEND PROPERTY BUILDSYSTEM_SOURCES ${sources})

  target_compile_definitions(${target} PUBLIC ALIEN_USE_SYCL USE_SYCL2020)

  IF(ALIEN_USE_HIPSYCL)
     add_sycl_to_target(TARGET  ${target}
                        SOURCES ${source})
  ENDIF()

  IF(ALIEN_USE_INTELSYCL)
     set(CMAKE_CXX_COMPILER ${ONEAPI_CXX_COMPILER})
     IF(ALIEN_USE_HIP)
       set(DPCPP_FLAGS -fsycl -Xsycl-target-backend=amdgcn-amd-amdhsa --offload-arch=gfx90a -Wno-linker-warnings)
       target_compile_options(${target} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${DPCPP_FLAGS}>)
     ENDIF()
     IF(ALIEN_USE_CUDA)
       set(DPCPP_FLAGS -fsycl -fsycl-targets=nvptx64-nvidia-cuda -Xsycl-target-backend=nvptx64-nvidia-cuda --cuda-gpu-arch=sm_80 -Wno-linker-warnings )
       target_compile_options(${target} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${DPCPP_FLAGS}>)
       target_link_options(${target} PRIVATE ${DPCPP_FLAGS})
     ENDIF()
     add_sycl_to_target(TARGET  ${target}
                        SOURCES ${source})
  ENDIF()
  IF(ALIEN_USE_ACPPSYCL)
    #IF(CMAKE_COMPILER_IS_GNUCXX)
      target_compile_options(${target} PRIVATE "--gcc-toolchain=${GCCCORE_ROOT}")
    #ENDIF()
    IF(ALIEN_USE_HIP)
      set(ACPP_FLAGS --hipsycl-gpu-arch=gfx90a --hipsycl-platform=rocm)
      target_compile_options(${target} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${ACPP_FLAGS}>)
    ENDIF()
    IF(ALIEN_USE_CUDA)
      #set(ACPP_FLAGS -fsycl -fsycl-targets=nvptx64-nvidia-cuda -Xsycl-target-backend=nvptx64-nvidia-cuda --cuda-gpu-arch=sm_80 -Wno-linker-warnings )
      #target_compile_options(alien_bench.exe PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${ACPP_FLAGS}>)
      #target_link_options(${target} PRIVATE ${ACPP_FLAGS})
    ENDIF()
    target_compile_definitions(${target} PRIVATE USE_ACPPSYCL)
    add_sycl_to_target(TARGET  ${target}
                       SOURCES ${source})
  ENDIF()
endfunction()