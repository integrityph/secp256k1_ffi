# make sure you compile for LInux/Windows/MacOS before you run this command from
# within the os folder inside the repo.
LD_LIBRARY_PATH=$PWD/linux/build/_deps/secp256k1-build/lib:$LD_LIBRARY_PATH flutter test /home/dev/workspace/secp256k1_ffi/test/ecdh/run_test.dart