import 'package:flutter_test/flutter_test.dart' as testing;
import 'grill_test_result.dart';

typedef GrillGroupFunc = GrillTestResult Function([int? iterations]);

GrillTestResult group(
  Object description,
  void Function() body, {
  dynamic skip,
  int? retry,
  int? iterations,
}) {
  iterations = iterations ?? 1;
  Stopwatch watch = Stopwatch();
  GrillTestResult results = GrillTestResult();
  results.runTime = List.filled(iterations, 0.0);
  for (int i = 0; i < iterations; i++) {
    watch.start();
    testing.group(description, body, skip: skip, retry: retry);
    watch.stop();
    results.runTime[i] = watch.elapsedTicks/watch.frequency;
    watch.reset();
  }
  return results;
}
