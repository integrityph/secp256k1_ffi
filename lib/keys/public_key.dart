import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:secp256k1_ffi/src/ffi_lib/ffi_lib.dart';
import 'package:secp256k1_ffi/src/helpers/conversion/list_to_bytearray.dart';
import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'package:secp256k1_ffi/src/bindings/bindings.dart' as bindings;

class PublicKey {
  const PublicKey();

  Uint8List? _serialize(List<int> pubKey, bool isCompressed) {
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      final pubkeyPtr = arena.allocate<bindings.secp256k1_pubkey>(ffi.sizeOf<bindings.secp256k1_pubkey>());

      final resultParsed = ffiBindings.secp256k1_ec_pubkey_parse(
        ctx,
        pubkeyPtr,
        pubKey.toUint8List().toFFIPointer(arena),
        pubKey.length,
      );

      if (resultParsed != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_parse returned $resultParsed instead of 1");
      }

      if (pubkeyPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_parse has failed");
      }

      final output = arena.allocate<ffi.UnsignedChar>(isCompressed ? 33 : 65);
      final outputlen = arena.allocate<ffi.Size>(ffi.sizeOf<ffi.Size>());

      final resultSerialized = ffiBindings.secp256k1_ec_pubkey_serialize(
        ctx,
        output,
        outputlen,
        pubkeyPtr,
        isCompressed 
          ? bindings.SECP256K1_EC_COMPRESSED
          : bindings.SECP256K1_EC_UNCOMPRESSED,
      );

      if (resultSerialized != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize returned $resultSerialized instead of 1");
        return null;
      }

      if (output != ffi.nullptr) {
        return returnUint8List(output.cast<ffi.Uint8>(), outputlen.value);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize has failed");
        return null;
      }
    });
  }

  Uint8List? toCompressed(List<int> pubKey) {
    return _serialize(pubKey, true);
  }

  Uint8List? toUncompressed(List<int> pubKey) {
    return _serialize(pubKey, false);
  }

  Uint8List? negate(List<int> publicKey) {
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      // parse
      final publicKeyPtr = arena.allocate<bindings.secp256k1_pubkey>(ffi.sizeOf<bindings.secp256k1_pubkey>());
      ffiBindings.secp256k1_ec_pubkey_parse(
        ctx,
        publicKeyPtr,
        publicKey.toUint8List().toFFIPointer(arena),
        publicKey.length,
      );

      final result = ffiBindings.secp256k1_ec_pubkey_negate(ctx, publicKeyPtr);

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_ec_seckey_negate returned $result instead of 1");
        return null;
      }

      if (publicKeyPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_seckey_negate has failed");
        return null;
      }

      // serialize
      final isCompressed = publicKey.length == 33;
      final outputPtr = arena.allocate<ffi.UnsignedChar>(publicKey.length);
      final outputLengthPtr = publicKey.length.toSizePointer(arena);
      final resultSerialize = ffiBindings.secp256k1_ec_pubkey_serialize(
        ctx,
        outputPtr,
        outputLengthPtr,
        publicKeyPtr,
        isCompressed ? bindings.SECP256K1_EC_COMPRESSED : bindings.SECP256K1_EC_UNCOMPRESSED,
      );

      if (resultSerialize != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize returned $resultSerialize instead of 1");
        return null;
      }

      if (outputPtr != ffi.nullptr) {
        return returnUint8List(outputPtr.cast<ffi.Uint8>(), outputLengthPtr.value);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize has failed");
        return null;
      }
    });
  }

  Uint8List? tweakAdd(List<int> publicKey, List<int> tweak) {
    if (tweak.length != 32) { return null; }
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      // parse
      final publicKeyPtr = arena.allocate<bindings.secp256k1_pubkey>(ffi.sizeOf<bindings.secp256k1_pubkey>());
      ffiBindings.secp256k1_ec_pubkey_parse(
        ctx,
        publicKeyPtr,
        publicKey.toUint8List().toFFIPointer(arena),
        publicKey.length,
      );

      final result = ffiBindings.secp256k1_ec_pubkey_tweak_add(
        ctx,
        publicKeyPtr,
        tweak.toUint8List().toFFIPointer(arena),
      );

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_tweak_add returned $result instead of 1");
        return null;
      }

      if (publicKeyPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_tweak_add has failed");
        return null;
      }

      // serialize
      final isCompressed = publicKey.length == 33;
      final outputPtr = arena.allocate<ffi.UnsignedChar>(publicKey.length);
      final outputLengthPtr = publicKey.length.toSizePointer(arena);
      final resultSerialize = ffiBindings.secp256k1_ec_pubkey_serialize(
        ctx,
        outputPtr,
        outputLengthPtr,
        publicKeyPtr,
        isCompressed ? bindings.SECP256K1_EC_COMPRESSED : bindings.SECP256K1_EC_UNCOMPRESSED,
      );

      if (resultSerialize != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize returned $resultSerialize instead of 1");
        return null;
      }

      if (outputPtr != ffi.nullptr) {
        return returnUint8List(outputPtr.cast<ffi.Uint8>(), outputLengthPtr.value);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize has failed");
        return null;
      }
    });
  }

  Uint8List? tweakMul(List<int> publicKey, List<int> tweak) {
    if (tweak.length != 32) { return null; }
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      // parse
      final publicKeyPtr = arena.allocate<bindings.secp256k1_pubkey>(ffi.sizeOf<bindings.secp256k1_pubkey>());
      ffiBindings.secp256k1_ec_pubkey_parse(
        ctx,
        publicKeyPtr,
        publicKey.toUint8List().toFFIPointer(arena),
        publicKey.length,
      );

      final result = ffiBindings.secp256k1_ec_pubkey_tweak_mul(
        ctx,
        publicKeyPtr,
        tweak.toUint8List().toFFIPointer(arena),
      );

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_tweak_mul returned $result instead of 1");
        return null;
      }

      if (publicKeyPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_tweak_mul has failed");
        return null;
      }

      // serialize
      final isCompressed = publicKey.length == 33;
      final outputPtr = arena.allocate<ffi.UnsignedChar>(publicKey.length);
      final outputLengthPtr = publicKey.length.toSizePointer(arena);
      final resultSerialize = ffiBindings.secp256k1_ec_pubkey_serialize(
        ctx,
        outputPtr,
        outputLengthPtr,
        publicKeyPtr,
        isCompressed ? bindings.SECP256K1_EC_COMPRESSED : bindings.SECP256K1_EC_UNCOMPRESSED,
      );

      if (resultSerialize != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize returned $resultSerialize instead of 1");
        return null;
      }

      if (outputPtr != ffi.nullptr) {
        return returnUint8List(outputPtr.cast<ffi.Uint8>(), outputLengthPtr.value);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize has failed");
        return null;
      }
    });
  }

  Uint8List? combine(List<List<int>> publicKeys) {
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      // parse
      final publicKeyListPtr = arena.allocate<ffi.Pointer<bindings.secp256k1_pubkey>>(ffi.sizeOf<ffi.Pointer<bindings.secp256k1_pubkey>>() * publicKeys.length);
      for (int i = 0; i < publicKeys.length; i++) {
        final publicKeyBytes = publicKeys[i];

        // 2. Allocate memory for ONE public key struct
        final pubKeyPtr = arena.allocate<bindings.secp256k1_pubkey>(ffi.sizeOf<bindings.secp256k1_pubkey>());

        // 3. Parse the raw bytes into that struct
        final parseResult = ffiBindings.secp256k1_ec_pubkey_parse(
          ctx,
          pubKeyPtr,
          publicKeyBytes.toUint8List().toFFIPointer(arena),
          publicKeyBytes.length,
        );

        if (parseResult != 1) {
          throw StateError('Failed to parse public key at index $i');
        }

        // 4. The Magic: Assign the pointer of this struct into the array of pointers
        publicKeyListPtr[i] = pubKeyPtr;
      }

      // combine
      final publicKeyPtr = arena.allocate<bindings.secp256k1_pubkey>(ffi.sizeOf<bindings.secp256k1_pubkey>());

      final result = ffiBindings.secp256k1_ec_pubkey_combine(
        ctx,
        publicKeyPtr,
        publicKeyListPtr,
        publicKeys.length,
      );

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_combine returned $result instead of 1");
        return null;
      }

      if (publicKeyPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_combine has failed");
        return null;
      }

      // serialize
      final isCompressed = publicKeys[0].length == 33;
      final outputPtr = arena.allocate<ffi.UnsignedChar>(publicKeys[0].length);
      final outputLengthPtr = publicKeys[0].length.toSizePointer(arena);
      final resultSerialize = ffiBindings.secp256k1_ec_pubkey_serialize(
        ctx,
        outputPtr,
        outputLengthPtr,
        publicKeyPtr,
        isCompressed ? bindings.SECP256K1_EC_COMPRESSED : bindings.SECP256K1_EC_UNCOMPRESSED,
      );

      if (resultSerialize != 1) {
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize returned $resultSerialize instead of 1");
        return null;
      }

      if (outputPtr != ffi.nullptr) {
        return returnUint8List(outputPtr.cast<ffi.Uint8>(), outputLengthPtr.value);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_ec_pubkey_serialize has failed");
        return null;
      }
    });
  }

  Uint8List? fromASN1(List<int> publicKey) {
    int offset = 0;

    // Helper to dynamically read DER length headers (handles both short and long form)
    int readLength() {
      if (offset >= publicKey.length) return -1;
      int len = publicKey[offset++];
      
      // If the high bit is set, it's a long-form length
      if ((len & 0x80) != 0) {
        int numBytes = len & 0x7F;
        if (offset + numBytes > publicKey.length) return -1;
        int result = 0;
        for (int i = 0; i < numBytes; i++) {
          result = (result << 8) | publicKey[offset++];
        }
        return result;
      }
      return len; // Short-form length
    }

    try {
      // 1. Read Outer Sequence (0x30)
      if (offset >= publicKey.length || publicKey[offset++] != 0x30) return null;
      int seqLen = readLength();
      if (seqLen < 0 || offset + seqLen > publicKey.length) return null;

      // 2. Read Algorithm Identifier Sequence (0x30)
      if (offset >= publicKey.length || publicKey[offset++] != 0x30) return null;
      int algSeqLen = readLength();
      if (algSeqLen < 0 || offset + algSeqLen > publicKey.length) return null;

      // 3. Strict OID Matching
      // We expect EXACTLY: id-ecPublicKey (1.2.840.10045.2.1) + secp256k1 (1.3.132.0.10)
      const expectedAlgId = [
        0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02, 0x01, // id-ecPublicKey
        0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x0a              // secp256k1
      ];

      if (offset + expectedAlgId.length > publicKey.length) return null;
      for (int i = 0; i < expectedAlgId.length; i++) {
        if (publicKey[offset++] != expectedAlgId[i]) {
          // This catches WrongCurve (secp256r1) and explicitly defined curves instantly!
          return null; 
        }
      }

      // 4. Read Bit String (0x03)
      if (offset >= publicKey.length || publicKey[offset++] != 0x03) return null;
      int bitStrLen = readLength();
      if (bitStrLen < 0 || offset + bitStrLen > publicKey.length) return null;

      // 5. Check Unused Bits Padding
      // A public key bit string must have 0 unused bits (0x00 padding byte)
      if (offset >= publicKey.length || publicKey[offset++] != 0x00) return null;

      // 6. Extract the Raw Point
      final rawKeyLen = bitStrLen - 1;
      
      // Secp256k1 keys MUST be exactly 33 bytes (compressed) or 65 bytes (uncompressed)
      if (rawKeyLen != 33 && rawKeyLen != 65) return null; 
      if (offset + rawKeyLen > publicKey.length) return null;

      return Uint8List.fromList(publicKey.sublist(offset, offset + rawKeyLen));
      
    } catch (e) {
      // Catch any unexpected out-of-bounds array access just in case
      return null;
    }
  }
}
