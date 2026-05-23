import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

class SafeArena {
  final Arena _internalArena = Arena();
  final List<ffi.Pointer> _sensitivePointers = [];
  final List<int> _sensitivePointersLength = [];

  /// Allocates memory, mimicking the original Arena's method.
  ffi.Pointer<T> allocate<T extends ffi.NativeType>(
    int byteCount, {
    bool isSensitive = true,
  }) {
    final ptr = _internalArena.allocate<T>(byteCount);
    if (isSensitive) {
      _sensitivePointers.add(ptr);
      _sensitivePointersLength.add(byteCount);
    }
    return ptr;
  }

  /// The new cleanup method that securely overwrites memory.
  void releaseAll() {
    for (int i=0; i<_sensitivePointers.length; i++) {
      final prt = _sensitivePointers[i];
      final length = _sensitivePointersLength[i];
      prt.cast<ffi.Uint8>().asTypedList(length).fillRange(0, length, 0);
    }
    _internalArena.releaseAll();
  }

  T using<T>(T resource, void Function(T) releaseCallback) {
    return _internalArena.using(resource, releaseCallback);
  }
}