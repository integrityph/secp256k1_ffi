import 'dart:math';

import 'package:blockchain_utils/crypto/crypto/hash/hash.dart';
import 'package:secp256k1_ffi/secp256k1_ffi.dart';
import 'package:secp256k1_ffi/src/encoding/encoding.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secp256k1_ffi/src/logging/logging.dart';

void testFunc(Map<String, dynamic> testVector) {
  // generate private key
  final privateKey = secp256k1FFI.privateKey.generate();
  expect(privateKey.length, 32);

  final publicKeyCompressed = secp256k1FFI.privateKey.createPubKey(privateKey, isCompressed: true);
  expect(publicKeyCompressed, isNotNull);
  publicKeyCompressed!;
  expect(publicKeyCompressed.length, 33);

  final publicKeyUncompressed = secp256k1FFI.privateKey.createPubKey(privateKey, isCompressed: false);
  expect(publicKeyUncompressed, isNotNull);
  publicKeyUncompressed!;
  expect(publicKeyUncompressed.length, 65);

  // Test negate
  final privateKeyNeg = secp256k1FFI.privateKey.negate(privateKey);
  expect(privateKeyNeg, isNotNull);
  privateKeyNeg!;
  expect(privateKeyNeg.length, 32);

  final publicKeyCompressedNeg = secp256k1FFI.publicKey.negate(publicKeyCompressed);
  expect(publicKeyCompressedNeg, isNotNull);
  publicKeyCompressedNeg!;
  expect(publicKeyCompressedNeg.length, 33);

  final publicKeyCompressedNegDer = secp256k1FFI.privateKey.createPubKey(privateKeyNeg);
  expect(publicKeyCompressedNegDer, isNotNull);
  publicKeyCompressedNegDer!;
  expect(publicKeyCompressedNegDer.length, 33);

  expect(publicKeyCompressedNeg, equals(publicKeyCompressedNegDer));

  // Test tweak add
  final random = Random.secure();
  final tweak = List.generate(32, (_)=>random.nextInt(256));
  final privateKeytadd = secp256k1FFI.privateKey.tweakAdd(privateKey, tweak);
  expect(privateKeytadd, isNotNull);
  privateKeytadd!;
  expect(privateKeytadd.length, 32);

  final publicKeyCompressedtadd = secp256k1FFI.publicKey.tweakAdd(publicKeyCompressed, tweak);
  expect(publicKeyCompressedtadd, isNotNull);
  publicKeyCompressedtadd!;
  expect(publicKeyCompressedtadd.length, 33);

  final publicKeyCompressedtaddDer = secp256k1FFI.privateKey.createPubKey(privateKeytadd);
  expect(publicKeyCompressedtaddDer, isNotNull);
  publicKeyCompressedtaddDer!;
  expect(publicKeyCompressedtaddDer.length, 33);

  expect(publicKeyCompressedtadd, equals(publicKeyCompressedtaddDer));

  
  // Test tweak mul
  final privateKeytmul = secp256k1FFI.privateKey.tweakMul(privateKey, tweak);
  expect(privateKeytmul, isNotNull);
  privateKeytmul!;
  expect(privateKeytmul.length, 32);

  final publicKeyCompressedtmul = secp256k1FFI.publicKey.tweakMul(publicKeyCompressed, tweak);
  expect(publicKeyCompressedtmul, isNotNull);
  publicKeyCompressedtmul!;
  expect(publicKeyCompressedtmul.length, 33);

  final publicKeyCompressedtmulDer = secp256k1FFI.privateKey.createPubKey(privateKeytmul);
  expect(publicKeyCompressedtmulDer, isNotNull);
  publicKeyCompressedtmulDer!;
  expect(publicKeyCompressedtmulDer.length, 33);

  expect(publicKeyCompressedtmul, equals(publicKeyCompressedtmulDer));


  final msg = List.generate(random.nextInt(65), (_)=>random.nextInt(256));

  final digest = SHA256.hash(msg);

  final sig = secp256k1FFI.ecdsa.sign(privateKey, digest);
  expect(sig, isNotNull);
  sig!;
  
  final valid = secp256k1FFI.ecdsa.verify(publicKeyCompressed, digest, sig);
  expect(valid, equals(true));
}
