// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'dart:math';
import 'dart:typed_data';
import 'package:secp256k1_ffi/src/ffi_lib/ffi_lib.dart';
import 'package:secp256k1_ffi/src/helpers/conversion/list_to_bytearray.dart';
import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'package:secp256k1_ffi/src/bindings/bindings.dart' as bindings;

class Schnorr {
  static const COMPRESSED_SIG_LENGTH = 64;

  const Schnorr();

  Uint8List? sign(List<int> privateKey, List<int> digest) {
    if (privateKey.length != 32) return null;
    if (digest.length != 32) return null;
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      // parse keypair
      final keypairPtr = arena.allocate<bindings.secp256k1_keypair>(ffi.sizeOf<bindings.secp256k1_keypair>());
      final resultParse = ffiBindings.secp256k1_keypair_create(
        ctx,
        keypairPtr,
        privateKey.toUint8List().toFFIPointer(arena),
      );


      if (resultParse != 1) {
        logger.log("Secp256k1.secp256k1_keypair_create returned $resultParse instead of 1");
        return null;
      }

      if (keypairPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_keypair_create has failed");
        return null;
      }

      // Sign
      final sigPtr = arena.allocate<ffi.UnsignedChar>(COMPRESSED_SIG_LENGTH);
      final random = Random.secure();
      final auxPtr = Uint8List.fromList(List.generate(32, (_)=>random.nextInt(256)));
      final result = ffiBindings.secp256k1_schnorrsig_sign32(
        ctx,
        sigPtr,
        digest.toUint8List().toFFIPointer(arena),
        keypairPtr,
        auxPtr.toFFIPointer(arena),
      );

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_schnorrsig_sign32 returned $result instead of 1");
        return null;
      }

      if (sigPtr != ffi.nullptr) {
        return returnUint8List(sigPtr.cast<ffi.Uint8>(), COMPRESSED_SIG_LENGTH);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_schnorrsig_sign32 has failed");
        return null;
      }


    });
  }

    bool? verify(List<int> publicKey, List<int> digest, List<int> sig) {
    if (sig.length != COMPRESSED_SIG_LENGTH) return false;
    if (digest.length != 32) return false;
    if (publicKey.length != 32 && publicKey.length != 33 && publicKey.length != 64 && publicKey.length != 65) { return false; }
    return arenaWrapper((SafeArena arena) {
      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

       // parse public key
      final xonlyPtr = arena.allocate<bindings.secp256k1_xonly_pubkey>(ffi.sizeOf<bindings.secp256k1_xonly_pubkey>());
      final List<int> xonlyPubKey = () {
        switch (publicKey.length) {
          case 32:
            return publicKey;
          case 33:
            return publicKey.sublist(1);
          case 64:
            return publicKey.sublist(0, 32);
          case 65:
            return publicKey.sublist(1, 33);
          default:
            return <int>[];
        }
      }();
      final resultParse = ffiBindings.secp256k1_xonly_pubkey_parse(
        ctx,
        xonlyPtr,
        xonlyPubKey.toUint8List().toFFIPointer(arena),
      );

      if (resultParse != 1) {
        logger.log("Secp256k1.secp256k1_xonly_pubkey_parse returned $resultParse instead of 1");
        return false;
      }

      if (xonlyPtr == ffi.nullptr) {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_xonly_pubkey_parse has failed");
        return false;
      }

      // Sign
      final resultSign = ffiBindings.secp256k1_schnorrsig_verify(
        ctx,
        sig.toUint8List().toFFIPointer(arena),
        digest.toUint8List().toFFIPointer(arena),
        digest.length,
        xonlyPtr
      );

      if (resultSign != 1) {
        return false;
      }

      return true;

    });
  }
}