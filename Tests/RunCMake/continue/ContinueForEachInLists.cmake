list(APPEND foo 1 2 3 4 5)

message(STATUS "start")
foreach(iter IN LISTS foo)
  if("${iter}" EQUAL 1 OR "${iter}" EQUAL 3 OR "${iter}" EQUAL 5)
    continue()
  endif()
  message(STATUS "${iter}")
endforeach()
message(STATUS "end")