import '../make_test/make_test_func.dart';

import 'test_vector/ecdsa_secp256k1_sha256_bitcoin_tv.dart' as ecdsa_secp256k1_sha256_bitcoin_tv;


import 'tests/ecdsa_secp256k1_sha256_bitcoin_verify.dart' as ecdsa_secp256k1_sha256_bitcoin_verify;
import 'tests/roundtrip.dart' as roundtrip;


final testList = [
  makeTest(
    "ecdsa_secp256k1_sha256_bitcoin_verify",
    ecdsa_secp256k1_sha256_bitcoin_tv.testVectorsStr,
    ecdsa_secp256k1_sha256_bitcoin_verify.testFunc,
    isJSON: true,
    jsonExtractor: (decodedJson) {
      final obj = decodedJson as Map<String, dynamic>;
      final baseName = "ecdsa_secp256k1_sha256_bitcoin_verify #{COUNTER}";
      final testGroups = obj["testGroups"] as List<dynamic>;
      final List<Map<String, dynamic>> allTests = [];
      for (final testGroup in testGroups){
        final publicKey = (testGroup["publicKey"] as Map<String, dynamic>)["uncompressed"] as String;
        final expandedTests = (testGroup["tests"] as List<dynamic>).map<Map<String, dynamic>>((v) {
          final testMap = v as Map<String, dynamic>;
          final testName = baseName.replaceAll("{COUNTER}", testMap["tcId"].toString());
          return {
            ...testMap,
            '_name': testName,
            'publicKey': publicKey,
          };
        }).toList();
        allTests.addAll(expandedTests);
      }

      return allTests;
    },
  ),

  makeTest(
    "ECDSA roundtrip",
    "{}",
    roundtrip.testFunc,
    isJSON: true,
    jsonExtractor: (decodedJson) {
      final baseName = "roundtrip #{COUNTER}";
      final List<Map<String, dynamic>> allTests = [];
      for (int i=0; i<200; i++) {
        final testName = baseName
          .replaceAll("{COUNTER}", (i+1).toString());
        allTests.add({
          '_name': testName,
        });
      } 

      return allTests;
    },
  ),
];
