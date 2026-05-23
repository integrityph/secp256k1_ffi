import '../make_test/make_test_func.dart';

import 'test_vector/tagged_sha256_tv.dart' as tagged_sha256_tv;

import 'tests/tagged_sha256_hash.dart' as tagged_sha256_hash;


final testList = [
  makeTest(
    "Tagged SHA256",
    tagged_sha256_tv.testVectorsStr,
    tagged_sha256_hash.testFunc,
    isJSON: true,
  ),
];
