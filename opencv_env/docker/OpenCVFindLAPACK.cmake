macro(_find_file_in_dirs VAR NAME DIRS)
    find_path(${VAR} ${NAME} ${DIRS} NO_DEFAULT_PATH)
    set(${VAR} ${${VAR}}/${NAME})
    unset(${VAR} CACHE)
endmacro()

if(WITH_LAPACK)
    ocv_update(LAPACK_IMPL "Unknown")
    if(NOT LAPACK_LIBRARIES)
        include(cmake/OpenCVFindMKL.cmake)
        if(HAVE_MKL)
            set(LAPACK_INCLUDE_DIR  ${MKL_INCLUDE_DIRS})
            set(LAPACK_LIBRARIES    ${MKL_LIBRARIES}   )
            set(LAPACK_CBLAS_H      "mkl_cblas.h"      )
            set(LAPACK_LAPACKE_H    "mkl_lapack.h"    )
            set(LAPACK_IMPL         "MKL")
        endif()
    endif()
    if(NOT LAPACK_LIBRARIES)
        include(cmake/OpenCVFindOpenBLAS.cmake)
        if(OpenBLAS_FOUND)
            set(LAPACK_INCLUDE_DIR  ${OpenBLAS_INCLUDE_DIR} )
            set(LAPACK_LIBRARIES    ${OpenBLAS_LIB}         )
            set(LAPACK_CBLAS_H      "cblas.h"      )
            set(LAPACK_LAPACKE_H    "lapacke.h"    )
            set(LAPACK_IMPL         "OpenBLAS")
        endif()
    endif()
    if(NOT LAPACK_LIBRARIES AND UNIX)
        include(cmake/OpenCVFindAtlas.cmake)
        if(ATLAS_FOUND)
            set(LAPACK_INCLUDE_DIR  ${Atlas_INCLUDE_DIR})
            set(LAPACK_LIBRARIES    ${Atlas_LIBRARIES}  )
            set(LAPACK_CBLAS_H      "cblas.h"      )
            set(LAPACK_LAPACKE_H    "lapacke.h"    )
            set(LAPACK_IMPL "Atlas")
        endif()
    endif()

    if(NOT LAPACK_LIBRARIES AND APPLE)
        set(LAPACK_INCLUDE_DIR  "Accelerate")
        set(LAPACK_LIBRARIES    "-framework Accelerate")
        set(LAPACK_CBLAS_H      "cblas.h"      )
        set(LAPACK_LAPACKE_H    "lapacke.h"    )
        set(LAPACK_IMPL         "Apple")
    endif()

    set(LAPACK_INCLUDE_DIR  ${LAPACK_INCLUDE_DIR}            CACHE PATH      "Path to BLAS include dir" FORCE)
    set(LAPACK_CBLAS_H      ${LAPACK_CBLAS_H}     CACHE STRING    "Alternative name of cblas.h" FORCE)
    set(LAPACK_LAPACKE_H    ${LAPACK_LAPACKE_H}   CACHE STRING    "Alternative name of lapacke.h" FORCE)
    set(LAPACK_LIBRARIES    ${LAPACK_LIBRARIES}            CACHE STRING    "Names of BLAS & LAPACK binaries (.so, .dll, .a, .lib)" FORCE)
    set(LAPACK_IMPL ${LAPACK_IMPL} CACHE STRING "Lapack implementation id" FORCE)

    if(LAPACK_LIBRARIES) #adding proxy cblas.h header
        message(STATUS "LAPACK_IMPL: ${LAPACK_IMPL}, LAPACK_LIBRARIES: ${LAPACK_LIBRARIES}")
        if("${LAPACK_IMPL}" STREQUAL "Apple")
            set(CBLAS_H_PATH "Accelerate/Accelerate.h")
            set(LAPACKE_H_PATH "Accelerate/Accelerate.h")
        else()
            _find_file_in_dirs(CBLAS_H_PATH "${LAPACK_CBLAS_H}" "${LAPACK_INCLUDE_DIR}")
            _find_file_in_dirs(LAPACKE_H_PATH "${LAPACK_LAPACKE_H}" "/usr/include")
        endif()
        if(NOT CBLAS_H_PATH OR NOT LAPACKE_H_PATH)
            message(WARNING "CBLAS/LAPACK headers are not found in '${LAPACK_INCLUDE_DIR}'")
        endif()
        ocv_include_directories(${LAPACK_INCLUDE_DIR})
        list(APPEND OPENCV_LINKER_LIBS ${LAPACK_LIBRARIES})
        set(HAVE_LAPACK 1)

        set(CBLAS_H_PROXY_PATH ${CMAKE_BINARY_DIR}/opencv_lapack.h)
        set(_include_str "\#include \"${CBLAS_H_PATH}\"")
        if("${CBLAS_H_PATH}" STREQUAL "${LAPACKE_H_PATH}")
        else()
            set(_include_str "${_include_str}\n\#include \"${LAPACKE_H_PATH}\"")
        endif()
        file(WRITE ${CBLAS_H_PROXY_PATH} ${_include_str})
    endif()
endif()
