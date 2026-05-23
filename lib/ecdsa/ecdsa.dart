import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:secp256k1_ffi/src/ffi_lib/ffi_lib.dart';
import 'package:secp256k1_ffi/src/helpers/conversion/list_to_bytearray.dart';
import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'package:secp256k1_ffi/src/bindings/bindings.dart' as bindings;

class ECDSA {
  // ignore: constant_identifier_names
  static const DER_MAX_LENGTH = 72;

  const ECDSA();

  Uint8List? sign(List<int> privateKey, List<int> digest, {bool isDER = true}) {
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      // Sign
      final sig = arena.allocate<bindings.secp256k1_ecdsa_signature>(ffi.sizeOf<bindings.secp256k1_ecdsa_signature>());

      final result = ffiBindings.secp256k1_ecdsa_sign(
        ctx,
        sig,
        digest.toUint8List().toFFIPointer(arena),
        privateKey.toUint8List().toFFIPointer(arena),
        ffi.nullptr,
        ffi.nullptr,
      );

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_ecdsa_sign returned $result instead of 1");
        return null;
      }

      if (sig == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ecdsa_sign has failed");
        return null;
      }

      // Normalize
      ffiBindings.secp256k1_ecdsa_signature_normalize(
        ctx,
        sig,
        sig,
      );

      if (sig == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ecdsa_signature_normalize has failed");
        return null;
      }

      // Serialize
      final sigPtr = arena.allocate<ffi.UnsignedChar>(DER_MAX_LENGTH);
      final sigLengthPtr = (isDER ? DER_MAX_LENGTH : 64).toSizePointer(arena);
      final resultSerialize = isDER
        ? ffiBindings.secp256k1_ecdsa_signature_serialize_der(ctx, sigPtr, sigLengthPtr, sig)
        : ffiBindings.secp256k1_ecdsa_signature_serialize_compact(ctx, sigPtr, sig);


      if (resultSerialize != 1) {
        logger.log("Secp256k1.secp256k1_ecdsa_signature_serialize returned $resultSerialize instead of 1");
        return null;
      }

      if (sigPtr != ffi.nullptr) {
        return returnUint8List(sigPtr.cast<ffi.Uint8>(), sigLengthPtr.value);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ecdsa_signature_serialize has failed");
        return null;
      }
    });
  }

  bool verify(List<int> publicKey, List<int> digest, List<int> sig) {
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      // Parse Signature
      final sigPtr = arena.allocate<bindings.secp256k1_ecdsa_signature>(ffi.sizeOf<bindings.secp256k1_ecdsa_signature>());
      
      int result = 0;

      if (sig.length != 64) {
        // MUST be DER (or invalid). Compact is strictly 64.
        result = ffiBindings.secp256k1_ecdsa_signature_parse_der(ctx, sigPtr, sig.toUint8List().toFFIPointer(arena), sig.length);
      } else {
        // It is exactly 64 bytes. 
        // If the first byte isn't 0x30, it is IMPOSSIBLE for it to be DER.
        if (sig[0] != 0x30) {
          result = ffiBindings.secp256k1_ecdsa_signature_parse_compact(ctx, sigPtr, sig.toUint8List().toFFIPointer(arena));
        } else {
          // 1 in 256 chance: A compact signature happens to start with 0x30, 
          // OR it actually is a legitimately rare 64-byte DER signature.
          result = ffiBindings.secp256k1_ecdsa_signature_parse_der(ctx, sigPtr, sig.toUint8List().toFFIPointer(arena), 64);
          if (result != 1) {
            result = ffiBindings.secp256k1_ecdsa_signature_parse_compact(ctx, sigPtr, sig.toUint8List().toFFIPointer(arena));
          }
        }
      }

      if (result != 1) {
        // logger.log("Secp256k1.secp256k1_ecdsa_signature_parse returned $result instead of 1");
        return false;
      }

      if (sigPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ecdsa_signature_parse has failed");
        return false;
      }

      // parse pubic key
      final pubkeyPtr = arena.allocate<bindings.secp256k1_pubkey>(ffi.sizeOf<bindings.secp256k1_pubkey>());
      final resultParse = ffiBindings.secp256k1_ec_pubkey_parse(
        ctx,
        pubkeyPtr,
        publicKey.toUint8List().toFFIPointer(arena),
        publicKey.length,
      );

      if (resultParse != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_parse returned $resultParse instead of 1");
        return false;
      }
      if (pubkeyPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_parse has failed");
        return false;
      }


      // Sign
      
      final resultSign = ffiBindings.secp256k1_ecdsa_verify(
        ctx,
        sigPtr,
        digest.toUint8List().toFFIPointer(arena),
        pubkeyPtr
      );

      if (resultSign != 1) {
        return false;
      }

      return true;

    });
  }
}