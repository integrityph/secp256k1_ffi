import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:secp256k1_ffi/src/ffi_lib/ffi_lib.dart';
import 'package:secp256k1_ffi/src/helpers/conversion/list_to_bytearray.dart';
import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'package:secp256k1_ffi/src/bindings/bindings.dart' as bindings;

class SHA256 {
  static const _SHA256_LENGTH = 32;
  const SHA256();

  Uint8List? hash(List<int> data, List<int> tag) {
    return arenaWrapper((SafeArena arena) {

      final ctx = arena.using(
        ffiBindings.secp256k1_context_create(bindings.SECP256K1_CONTEXT_NONE),
        ffiBindings.secp256k1_context_destroy
      );

      final hash32 = arena.allocate<ffi.UnsignedChar>(_SHA256_LENGTH);

      final result = ffiBindings.secp256k1_tagged_sha256(
        ctx,
        hash32,
        tag.toUint8List().toFFIPointer(arena),
        tag.length,
        data.toUint8List().toFFIPointer(arena),
        data.length,
      );

      if (result != 1) {
        logger.log("Secp256k1.secp256k1_tagged_sha256 returned $result instead of 1");
        return null;
      }

      if (hash32 != ffi.nullptr) {
        return returnUint8List(hash32.cast<ffi.Uint8>(), _SHA256_LENGTH);
      } else {
        // This is a rare failure case for the SHA1 function.
        logger.log("Secp256k1.secp256k1_tagged_sha256 has failed");
        return null;
      }
    });
  }
}