import 'package:secp256k1_ffi/secp256k1_ffi.dart';
import 'package:secp256k1_ffi/src/encoding/encoding.dart';
import 'package:flutter_test/flutter_test.dart';

void testFunc(Map<String, dynamic> testVector) {
  final rawPrivateKey = hex.decode(testVector['private'] as String);
  final rawPublicKey = hex.decode(testVector['public'] as String);
  final shared = hex.decode(testVector['shared'] as String);
  final expectedResult = testVector['result'] as String;

  //rawPublicKey.sublist(rawPublicKey.length > 65 ? rawPublicKey.length-65 : rawPublicKey.length > 33 ? rawPublicKey.length-33 : 0);
  final privateKey = (List.filled(rawPrivateKey.length < 32 ? 32 - rawPrivateKey.length : 0, 0) + rawPrivateKey).sublist(rawPrivateKey.length >= 32 ? rawPrivateKey.length-32 : 0);
  final publicKey = secp256k1FFI.publicKey.fromASN1(rawPublicKey);
  if (publicKey == null) {
    expect(expectedResult, anyOf("invalid", "acceptable"));
    return;
  }

  final actualMsg = secp256k1FFI.ecdh.deriveKey(publicKey, privateKey, useSHA256: false);
  
  if (expectedResult == "invalid") {
    expect(actualMsg, isNull);
    return;
  } else if (expectedResult == "acceptable" && actualMsg == null) {
    return;
  }

  expect(actualMsg, isNotNull);
  actualMsg!;
  expect(actualMsg, equals(shared), reason: "Failed match of shared key expected ${hex.encode(shared)} got ${hex.encode(actualMsg)}");
}
