# CMake generated Testfile for 
# Source directory: /home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-src/src
# Build directory: /home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-build/src
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test([=[secp256k1_noverify_tests]=] "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-build/bin/noverify_tests")
set_tests_properties([=[secp256k1_noverify_tests]=] PROPERTIES  _BACKTRACE_TRIPLES "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-src/src/CMakeLists.txt;150;add_test;/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-src/src/CMakeLists.txt;0;")
add_test([=[secp256k1_tests]=] "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-build/bin/tests")
set_tests_properties([=[secp256k1_tests]=] PROPERTIES  _BACKTRACE_TRIPLES "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-src/src/CMakeLists.txt;155;add_test;/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-src/src/CMakeLists.txt;0;")
add_test([=[secp256k1_exhaustive_tests]=] "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-build/bin/exhaustive_tests")
set_tests_properties([=[secp256k1_exhaustive_tests]=] PROPERTIES  _BACKTRACE_TRIPLES "/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-src/src/CMakeLists.txt;165;add_test;/home/dev/workspace/secp256k1_ffi/src/build/_deps/secp256k1-src/src/CMakeLists.txt;0;")
