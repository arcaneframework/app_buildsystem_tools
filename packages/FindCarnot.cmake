#
# Find the CARNOT includes and libraries 
# using standard cmake find_package(Carnot) 
# avalaible since carnot Carnot/11.3.10381

find_package(Carnot COMPONENTS carnot_interface)

if(${Carnot_FOUND} AND TARGET Carnot::carnot_interface)
  add_library(carnot ALIAS Carnot::carnot_interface)
  add_definitions(-DUSE_CARNOT)
endif()
