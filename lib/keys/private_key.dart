import 'dart:ffi' as ffi;
import 'dart:math';
import 'dart:typed_data';
import 'package:secp256k1_ffi/src/ffi_lib/ffi_lib.dart';
import 'package:secp256k1_ffi/src/helpers/conversion/list_to_bytearray.dart';
import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'package:secp256k1_ffi/src/bindings/bindings.dart' as bindings;

class PrivateKey {
  const PrivateKey();

  bool verify(List<int> privateKey) {
    if (privateKey.length != 32) return false;
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      final result = ffiBindings.secp256k1_ec_seckey_verify(
        ctx,
        privateKey.toUint8List().toFFIPointer(arena),
      );

      if (result != 1) {
        return false;
      }
      return true;
    });
  }

  Uint8List? createPubKey(List<int> privateKey, {bool isCompressed=true}) {
    if (privateKey.length != 32) return null;
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      // Derive public from private
      final pubKeyPtr = arena.allocate<bindings.secp256k1_pubkey>(ffi.sizeOf<bindings.secp256k1_pubkey>());

      final result = ffiBindings.secp256k1_ec_pubkey_create(
        ctx,
        pubKeyPtr,
        privateKey.toUint8List().toFFIPointer(arena),
      );

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_create returned $result instead of 1");
        return null;
      }

      if (pubKeyPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_create has failed");
        return null;
      }

      // serialize

      final outputPtr = arena.allocate<ffi.UnsignedChar>(isCompressed ? 33 : 65);
      final outputLenPtr = (isCompressed ? 33 : 65).toSizePointer(arena);
      final resultSerialize = ffiBindings.secp256k1_ec_pubkey_serialize(
        ctx,
        outputPtr,
        outputLenPtr,
        pubKeyPtr,
        isCompressed ? bindings.SECP256K1_EC_COMPRESSED : bindings.SECP256K1_EC_UNCOMPRESSED,
      );

      if (resultSerialize != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize returned $resultSerialize instead of 1");
        return null;
      }

      if (outputPtr != ffi.nullptr) {
        return returnUint8List(outputPtr.cast<ffi.Uint8>(), outputLenPtr.value);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize has failed");
        return null;
      }
    });
  }

  Uint8List? negate(List<int> privateKey) {
    if (privateKey.length != 32) return null;
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      final privateKeyPtr = privateKey.toUint8List().toFFIPointer<ffi.UnsignedChar>(arena);

      final result = ffiBindings.secp256k1_ec_seckey_negate(ctx, privateKeyPtr);

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_ec_seckey_negate returned $result instead of 1");
        return null;
      }

      if (privateKeyPtr != ffi.nullptr) {
        return returnUint8List(privateKeyPtr.cast<ffi.Uint8>(), privateKey.length);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_seckey_negate has failed");
        return null;
      }
    });
  }

  Uint8List? tweakAdd(List<int> privateKey, List<int> tweak) {
    if (tweak.length != 32) return null;
    if (privateKey.length != 32) return null;
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      final privateKeyPtr = privateKey.toUint8List().toFFIPointer<ffi.UnsignedChar>(arena);

      final result = ffiBindings.secp256k1_ec_seckey_tweak_add(
        ctx,
        privateKeyPtr,
        tweak.toUint8List().toFFIPointer(arena),
      );

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_ec_seckey_tweak_add returned $result instead of 1");
        return null;
      }

      if (privateKeyPtr != ffi.nullptr) {
        return returnUint8List(privateKeyPtr.cast<ffi.Uint8>(), privateKey.length);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_seckey_tweak_add has failed");
        return null;
      }
    });
  }

  Uint8List? tweakMul(List<int> privateKey, List<int> tweak) {
    if (tweak.length != 32) return null;
    if (privateKey.length != 32) return null;
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      final privateKeyPtr = privateKey.toUint8List().toFFIPointer<ffi.UnsignedChar>(arena);

      final result = ffiBindings.secp256k1_ec_seckey_tweak_mul(
        ctx,
        privateKeyPtr,
        tweak.toUint8List().toFFIPointer(arena),
      );

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_ec_seckey_tweak_mul returned $result instead of 1");
        return null;
      }

      if (privateKeyPtr != ffi.nullptr) {
        return returnUint8List(privateKeyPtr.cast<ffi.Uint8>(), privateKey.length);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_seckey_tweak_mul has failed");
        return null;
      }
    });
  }

  Uint8List generate() {
    final random = Random.secure();
    while (true) {
      final privateKey = Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));
      final valid = verify(privateKey);
      if (valid) { return privateKey; }
    }
  }
}