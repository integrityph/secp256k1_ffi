import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:secp256k1_ffi/src/ffi_lib/ffi_lib.dart';
import 'package:secp256k1_ffi/src/helpers/conversion/list_to_bytearray.dart';
import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'package:secp256k1_ffi/src/bindings/bindings.dart' as bindings;

class ECDH {
  // ignore: constant_identifier_names
  static const _SHA256_LEN = 32;
  const ECDH();

  static int _rawXCoordinateHash(
    ffi.Pointer<ffi.UnsignedChar> output,
    ffi.Pointer<ffi.UnsignedChar> x32,
    ffi.Pointer<ffi.UnsignedChar> y32,
    ffi.Pointer<ffi.Void> data,
  ) {
    // Simply copy the raw X-coordinate directly into the output buffer
    for (int i = 0; i < 32; i++) {
      output[i] = x32[i];
    }
    return 1; // 1 means success
  }

  Uint8List? deriveKey(List<int> publicKey, List<int> privateKey, {bool useSHA256=true}) {
    if (privateKey.length != 32) return null;
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      // parse public key

      final pubkeyPtr = arena.allocate<bindings.secp256k1_pubkey>(ffi.sizeOf<bindings.secp256k1_pubkey>());
      final resultParse = ffiBindings.secp256k1_ec_pubkey_parse(
        ctx,
        pubkeyPtr,
        publicKey.toUint8List().toFFIPointer(arena),
        publicKey.length,
      );

      if (resultParse != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_parse returned $resultParse instead of 1");
        return null;
      }

      if (pubkeyPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_parse has failed");
        return null;
      }

      // derive shared secret

      final outputPtr = arena.allocate<ffi.UnsignedChar>(_SHA256_LEN);

      final hashFunctionPtr = ffi.Pointer.fromFunction<
        ffi.Int Function(
          ffi.Pointer<ffi.UnsignedChar>,
          ffi.Pointer<ffi.UnsignedChar>,
          ffi.Pointer<ffi.UnsignedChar>,
          ffi.Pointer<ffi.Void>
        )
      >(_rawXCoordinateHash, 0);

      final result = ffiBindings.secp256k1_ecdh(
        ctx,
        outputPtr,
        pubkeyPtr,
        privateKey.toUint8List().toFFIPointer(arena),
        useSHA256 ? ffi.nullptr : hashFunctionPtr,
        ffi.nullptr,
      );

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_ecdh returned $result instead of 1");
        return null;
      }

      if (outputPtr != ffi.nullptr) {
        return returnUint8List(outputPtr.cast<ffi.Uint8>(), _SHA256_LEN);
      } else {
        logger.log("Secp256k1.secp256k1_ecdh has failed");
        return null;
      }
    });
  }
}