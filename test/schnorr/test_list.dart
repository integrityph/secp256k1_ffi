import '../make_test/make_test_func.dart';


import 'tests/roundtrip.dart' as roundtrip;


final testList = [
  makeTest(
    "Schnorr roundtrip",
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
