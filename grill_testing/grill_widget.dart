import 'package:flutter_test/flutter_test.dart' as testing;
import 'package:leak_tracker_testing/src/leak_testing.dart';

import 'grill_test_result.dart';

GrillTestResult testWidgets(
  String description,
  Future<void> Function(testing.WidgetTester) callback, {
  bool? skip,
  testing.Timeout? timeout,
  bool semanticsEnabled = true,
  testing.TestVariant<Object?> variant = const testing.DefaultTestVariant(),
  dynamic tags,
  int? retry,
  LeakTesting? experimentalLeakTesting,
  int iterations = 1,
}) {
  Stopwatch watch = Stopwatch();
  GrillTestResult results = GrillTestResult();
  results.runTime = List.filled(iterations, 0.0);
  for (int i = 0; i < iterations; i++) {
    watch.start();
    testing.testWidgets(
      description,
      callback,
      skip: skip,
      timeout: timeout,
      semanticsEnabled: semanticsEnabled,
      variant: variant,
      tags: tags,
      retry: retry,
      experimentalLeakTesting: experimentalLeakTesting,
    );
    watch.stop();
    results.runTime[i] = watch.elapsedTicks/watch.frequency;
    watch.reset();
  }
  return results;
}
