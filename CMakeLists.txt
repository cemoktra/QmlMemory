cmake_minimum_required(VERSION 3.5)

project(QmlMemory LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(HEADERS
  normal_random.h
)

set(SOURCES
  main.cpp
  normal_random.cpp
)

set(RESOURCES
  qml.qrc
)

if (WIN32)
  set(Qt5_DIR "C:/Qt/5.13.1/mingw73_64/lib/cmake/Qt5")
endif()
find_package(Qt5 COMPONENTS Core Quick REQUIRED)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  add_executable(QmlMemory ${HEADERS} ${SOURCES} ${RESOURCES})
else()
  add_executable(QmlMemory WIN32 ${HEADERS} ${SOURCES} ${RESOURCES})  
endif()

target_compile_definitions(QmlMemory
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(QmlMemory
  PRIVATE Qt5::Core Qt5::Quick Qt5::Gui Qt5::Qml Qt5::Network tbb)

if (WIN32)
  add_custom_command(TARGET QmlMemory POST_BUILD 
    COMMAND "${CMAKE_COMMAND}" -E copy $<TARGET_FILE:Qt5::Core> ${CMAKE_BINARY_DIR}
    COMMAND "${CMAKE_COMMAND}" -E copy $<TARGET_FILE:Qt5::Gui> ${CMAKE_BINARY_DIR}
    COMMAND "${CMAKE_COMMAND}" -E copy $<TARGET_FILE:Qt5::Quick> ${CMAKE_BINARY_DIR}
    COMMAND "${CMAKE_COMMAND}" -E copy $<TARGET_FILE:Qt5::Qml> ${CMAKE_BINARY_DIR}
    COMMAND "${CMAKE_COMMAND}" -E copy $<TARGET_FILE:Qt5::Network> ${CMAKE_BINARY_DIR}
  )  
endif()