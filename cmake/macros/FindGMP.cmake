# .. cmake_module::
#
#    Find the GNU MULTI-Precision Bignum (GMP) library
#    and the corresponding C++ bindings GMPxx
#
#    You may set the following variables to modify the
#    behaviour of this module:
#
#    :ref:`GMP_ROOT`
#       Path list to search for GMP and GMPxx
#
#    Sets the following variables:
#
#    :code:`GMP_FOUND`
#       True if the GMP library, the GMPxx headers and
#       the GMPxx library were found.
#
# .. cmake_variable:: GMP_ROOT
#
#   You may set this variable to have :ref:`FindGMP` look
#   for the gmp and gmpxx packages in the given path before
#   inspecting system paths.
#


# search for location of header gmpxx.h", only at positions given by the user
find_path(GMPXX_INCLUDE_DIR
  NAMES "gmpxx.h"
  PATHS ${GMP_PREFIX} ${GMP_ROOT}
  PATH_SUFFIXES include
  NO_DEFAULT_PATH)
# try default paths now
find_path(GMPXX_INCLUDE_DIR
  NAMES "gmpxx.h")

# check if header is accepted
include(CMakePushCheckState)
cmake_push_check_state()
set(CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES} ${GMPXX_INCLUDE_DIR})
include(CheckIncludeFileCXX)
check_include_file_cxx("gmpxx.h" GMP_HEADER_WORKS)

# look for library gmp, only at positions given by the user
find_library(GMP_LIB
  NAMES gmp libgmp
  PATHS ${GMP_PREFIX} ${GMP_ROOT} "/usr/lib/x86_64-linux-gnu"
  PATH_SUFFIXES lib lib64
  NO_DEFAULT_PATH
  DOC "GNU GMP library")
# try default paths now
find_library(GMP_LIB
 NAMES libgmp gmp)

# look for library gmpxx, only at positions given by the user
find_library(GMPXX_LIB
  NAMES gmpxx libgmpxx
  PATHS ${GMP_PREFIX} ${GMP_ROOT} "/usr/lib/x86_64-linux-gnu"
  PATH_SUFFIXES lib lib64
  NO_DEFAULT_PATH
  DOC "GNU GMPXX library")
# try default paths now
find_library(GMPXX_LIB
  NAMES libgmpxx gmpxx)

# check if library works
if(GMP_LIB AND GMPXX_LIB)
  include(CheckSymbolExists)
  check_library_exists(${GMP_LIB} __gmpz_abs "" GMPXX_LIB_WORKS)
endif(GMP_LIB AND GMPXX_LIB)
cmake_pop_check_state()

# behave like a CMake module is supposed to behave
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  "GMP"
  DEFAULT_MSG
  GMPXX_INCLUDE_DIR GMP_LIB GMPXX_LIB GMP_HEADER_WORKS GMPXX_LIB_WORKS
)

mark_as_advanced(GMP_LIB GMPXX_LIB GMPXX_INCLUDE_DIR)

# if GMPxx headers, GMP library, and GMPxx library are found, store results
if(GMP_FOUND)
  set(GMP_INCLUDE_DIRS ${GMPXX_INCLUDE_DIR})
  set(GMP_LIBRARIES ${GMP_LIB} ${GMPXX_LIB})
  set(GMP_COMPILE_FLAGS "-DENABLE_GMP=1")
  # log result
  file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
    "Determining location of GMP, GMPxx succeeded:\n"
    "Include directory: ${GMP_INCLUDE_DIRS}\n"
    "Library directory: ${GMP_LIBRARIES}\n\n")
else()
  # log errornous result
  file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining location of GMP, GMPxx failed:\n"
    "Include directory: ${GMPXX_INCLUDE_DIR}\n"
    "gmp library directory: ${GMP_LIB}\n"
    "gmpxx library directory: ${GMPXX_LIB}\n\n")
endif()

# set HAVE_GMP for config.h
set(HAVE_GMP ${GMP_FOUND})
