# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-src"
  "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-build"
  "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-subbuild/secp256k1-populate-prefix"
  "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-subbuild/secp256k1-populate-prefix/tmp"
  "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-subbuild/secp256k1-populate-prefix/src/secp256k1-populate-stamp"
  "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-subbuild/secp256k1-populate-prefix/src"
  "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-subbuild/secp256k1-populate-prefix/src/secp256k1-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-subbuild/secp256k1-populate-prefix/src/secp256k1-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-subbuild/secp256k1-populate-prefix/src/secp256k1-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
