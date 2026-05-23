import 'package:blockchain_utils/crypto/crypto/hash/hash.dart';
import 'package:secp256k1_ffi/secp256k1_ffi.dart';
import 'package:secp256k1_ffi/src/encoding/encoding.dart';
import 'package:flutter_test/flutter_test.dart';

void testFunc(Map<String, dynamic> testVector) {
  final msg = hex.decode(testVector['msg'] as String);
  final publicKey = hex.decode(testVector['publicKey'] as String);
  final sig = hex.decode(testVector['sig'] as String);
  final expectedResult = testVector['result'] as String;

  final digest = SHA256.hash(msg);

  final actualMsg = secp256k1FFI.ecdsa.verify(publicKey, digest, sig);

  expect(actualMsg, expectedResult=="valid" ? equals(true) : equals(false));
}
