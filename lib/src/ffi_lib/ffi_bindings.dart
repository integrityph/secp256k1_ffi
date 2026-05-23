import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'package:secp256k1_ffi/src/bindings/bindings.dart';

final _ffiBindingsInstance = _FFIBindings();
final ffiBindings = _ffiBindingsInstance.bindings;
final ffiLookupFunc = _FFIBindings.dynamicLibrary.lookup;

class _FFIBindings {
  static final _libName = 'secp256k1_ffi';
  static final ffi.DynamicLibrary dynamicLibrary = _openDylib();
  final Secp256k1Bindings bindings;

  _FFIBindings() : bindings = _getBindings();

  static Secp256k1Bindings _getBindings() {
    return Secp256k1Bindings(dynamicLibrary);
  }

  static ffi.DynamicLibrary _openDylib() {
    try {
      if (Platform.isMacOS || Platform.isIOS) {
        // For Apple platforms, the FFI plugin system builds a framework.
        return ffi.DynamicLibrary.open('$_libName.framework/$_libName');
      }
      if (Platform.isAndroid || Platform.isLinux) {
        // For Linux and Android, it's a standard shared object.
        return ffi.DynamicLibrary.open('lib$_libName.so');
      }
      if (Platform.isWindows) {
        // For Windows, it's a dynamic-link library.
        return ffi.DynamicLibrary.open('$_libName.dll');
      }
    } catch (e) {
      logger.log("_openDylib failed to open secp256k1 binary. $e");
      rethrow;
    }
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }
}
