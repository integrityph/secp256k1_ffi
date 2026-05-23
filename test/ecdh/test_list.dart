import '../make_test/make_test_func.dart';

import 'test_vector/ecdh_secp256k1_tv.dart' as ecdh_secp256k1_tv;

import 'tests/ecdh_secp256k1_derivekey.dart' as ecdh_secp256k1_derivekey;


final testList = [
  makeTest(
    "ecdh_secp256k1_derivekey",
    ecdh_secp256k1_tv.testVectorsStr,
    ecdh_secp256k1_derivekey.testFunc,
    isJSON: true,
    jsonExtractor: (decodedJson) {
      final obj = decodedJson as Map<String, dynamic>;
      final baseName = "ecdh_secp256k1_derivekey #{COUNTER}";
      final testGroups = obj["testGroups"] as List<dynamic>;
      final List<Map<String, dynamic>> allTests = [];
      for (final testGroup in testGroups){
        final expandedTests = (testGroup["tests"] as List<dynamic>).map<Map<String, dynamic>>((v) {
          final testMap = v as Map<String, dynamic>;
          final testName = baseName.replaceAll("{COUNTER}", testMap["tcId"].toString());
          return {
            ...testMap,
            '_name': testName,
          };
        }).toList();
        allTests.addAll(expandedTests);
      }

      return allTests;
    },
  ),
];
