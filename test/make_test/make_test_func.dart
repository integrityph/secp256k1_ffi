import 'dart:convert';
import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stack_trace/stack_trace.dart';
import '../parsing.dart';

Function() makeTest(
  String name,
  String testVector,
  Function(Map<String, dynamic> testVector) testFunc, {
  bool Function(Map<String, dynamic>)? testVectorFilter,
  Map<String, dynamic> Function(Map<String, dynamic> sample)?
  testVectorModifier,
  dynamic tags,
  String keyValueSeparator = ":",
  String unnamedTagKey = "",
  bool isJSON = false,
  Iterable<dynamic> Function(dynamic decodedJson)? jsonExtractor,
}) {
  return () {
    group(name, () {
      List<Map<String, dynamic>> testVectors;
      if (isJSON) {
        final decoded = jsonDecode(testVector);
        
        // 1. Extract the iterable list using the callback (or default to raw list)
        final Iterable<dynamic> rawList = jsonExtractor != null 
            ? jsonExtractor(decoded) 
            : (decoded as List<dynamic>);
            
        // 2. Cast to the expected Map format
        testVectors = rawList.map<Map<String, dynamic>>((sample) => sample as Map<String, dynamic>).toList();
      } else {
        testVectors = keyValueToJSON(
        testVector,
        "",
        separator: keyValueSeparator,
        unnamedTagKey: unnamedTagKey,
      );
      }
      

      if (testVectorFilter != null) {
        testVectors = testVectors.where(testVectorFilter).toList();
      }

      if (testVectorModifier != null) {
        testVectors = testVectors
            .map<Map<String, dynamic>>(testVectorModifier)
            .toList();
      }

      int failCount = 0;
      for (final testVector in testVectors) {
        test(testVector['_name'], () {
          try {
            testFunc(testVector);
          } catch (e, stack) {
            prettyPrintJSON(testVector);
            logger.configure(showStackTraces: true);
            logger.log(
              "error in unit test ${testVector['_name']}: $e\n${Trace.current()}\nSTACK:\n$stack",
            );
            failCount++;
            rethrow;
          }
        }, tags: tags);
      }
      tearDownAll(() {
        logger.log(
          "$name finished with ${testVectors.length - failCount}/${testVectors.length} passing",
          Level.info,
        );
      });
    });
  };
}

void prettyPrintJSON(dynamic val) {
  final encoder = JsonEncoder.withIndent('  ');
  final String json = encoder.convert(val);
  logger.log(json, Level.info);
}
