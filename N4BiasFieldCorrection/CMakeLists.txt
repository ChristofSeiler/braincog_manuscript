cmake_minimum_required(VERSION 2.4)
if(COMMAND CMAKE_POLICY)
  cmake_policy(SET CMP0003 NEW)
endif(COMMAND CMAKE_POLICY)

PROJECT(N4BiasFieldCorrection)

FIND_PACKAGE(ITK)
IF(ITK_FOUND)
INCLUDE(${USE_ITK_FILE})
ENDIF(ITK_FOUND)

INCLUDE_DIRECTORIES(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}
)

SET(N4BiasFieldCorrectionHeaders
)

SET(N4BiasFieldCorrectionSrcs
  ${N4BiasFieldCorrection_SOURCE_DIR}/src/Main.cxx
)

ADD_EXECUTABLE( N4BiasFieldCorrection ${N4BiasFieldCorrectionHeaders} ${N4BiasFieldCorrectionSrcs})

TARGET_LINK_LIBRARIES( N4BiasFieldCorrection
  ${ITK_LIBRARIES}
)
