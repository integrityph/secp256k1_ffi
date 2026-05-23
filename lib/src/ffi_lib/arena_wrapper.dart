import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'safe_arena.dart';
export 'package:ffi/ffi.dart';

dynamic arenaWrapper(Function(SafeArena arena) fun) {
  final arena = SafeArena();
  try {
    return fun(arena);
  } catch (e) {
    logger.log("_arenaWrapper: function call failed. $e");
    return null;
  } finally {
    arena.releaseAll();
  }
}

Uint8List returnUint8List(ffi.Pointer<ffi.Uint8> pointer, int length) {
  return Uint8List.fromList(List<int>.from(pointer.asTypedList(length)));
}
