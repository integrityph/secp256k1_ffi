cmake_minimum_required(VERSION 3.10.2)
project(secp256k1_ffi C) # This fixes the warnings

include(FetchContent)

FetchContent_Declare(
  secp256k1
  GIT_REPOSITORY https://github.com/bitcoin-core/secp256k1
  GIT_TAG        v0.7.1
)

option(SECP256K1_ENABLE_MODULE_ECDH "Enable ECDH module." ON)
option(SECP256K1_ENABLE_MODULE_RECOVERY "Enable ECDSA pubkey recovery module." ON)
option(SECP256K1_ENABLE_MODULE_EXTRAKEYS "Enable extrakeys module." ON)
option(SECP256K1_ENABLE_MODULE_SCHNORRSIG "Enable schnorrsig module." ON)
option(SECP256K1_ENABLE_MODULE_MUSIG "Enable musig module." ON)
option(SECP256K1_ENABLE_MODULE_ELLSWIFT "Enable ElligatorSwift module." ON)

# CRITICAL FIX: Tell CMake to build shared (.so) libraries 
# BEFORE it configures the secp256k1 repository.
set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(secp256k1)

set_target_properties(secp256k1 PROPERTIES OUTPUT_NAME "secp256k1_ffi")

target_link_options(secp256k1 PRIVATE "-Wl,-z,max-page-size=0x4000")

add_library(secp256k1_ffi SHARED IMPORTED)
#set_target_properties(secp256k1_ffi PROPERTIES IMPORTED_LOCATION secp256k1)