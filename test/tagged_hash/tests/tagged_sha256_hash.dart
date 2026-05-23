import 'package:secp256k1_ffi/secp256k1_ffi.dart';
import 'package:secp256k1_ffi/src/encoding/encoding.dart';
import 'package:flutter_test/flutter_test.dart';

void testFunc(Map<String, dynamic> testVector) {
  final msg = hex.decode(testVector['msg'] as String);
  final tag = hex.decode(testVector['tag'] as String);
  final expectedDigest = hex.decode(testVector['digest'] as String);
  final shouldPass = testVector['shouldPass'] as bool;

  final actualDigest = secp256k1FFI.taggedSHA256.hash(msg, tag);

  expect(actualDigest, shouldPass ? isNotNull : isNull);
  actualDigest!;

  expect(actualDigest, equals(expectedDigest));
}
