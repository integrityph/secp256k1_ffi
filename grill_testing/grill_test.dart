import 'package:flutter_test/flutter_test.dart' as testing;
import 'grill_test_result.dart';

GrillTestResult test(
  Object description,
  dynamic Function() body, {
  String? testOn,
  testing.Timeout? timeout,
  dynamic skip,
  dynamic tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
  int? iterations,
}) {
  iterations = iterations ?? 1;
  // Stopwatch watch = Stopwatch();
  GrillTestResult results = GrillTestResult();
  // results.runTime = List.filled(iterations, Duration());
  // for (int i = 0; i < iterations; i++) {
  // watch.start();
  testing.test(
    description,
    body,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
  //   watch.stop();
  //   results.runTime[i] = watch.elapsed;
  //   watch.reset();
  // }
  // List<int> timeMs = results.runTime.map<int>((d) => d.inMilliseconds).toList();
  // final int sumMs = timeMs.reduce((a, b) => a + b);
  // final double avgMs = timeMs.isEmpty ? 0.0 : sumMs / timeMs.length;
  // final int minMs = timeMs.isEmpty ? 0 : timeMs.reduce((a, b) => a < b ? a : b);
  // final int maxMs = timeMs.isEmpty ? 0 : timeMs.reduce((a, b) => a > b ? a : b);
  // double medianMs = 0.0;
  // if (timeMs.isNotEmpty) {
  //   // Create a mutable copy to sort
  //   final List<int> sortedTimeMs = List<int>.from(timeMs)..sort();
  //   final int middle = sortedTimeMs.length ~/ 2; // Integer division

  //   if (sortedTimeMs.length % 2 == 1) {
  //     // Odd number of elements: median is the middle element
  //     medianMs = sortedTimeMs[middle].toDouble();
  //   } else {
  //     // Even number of elements: median is the average of the two middle elements
  //     medianMs = (sortedTimeMs[middle - 1] + sortedTimeMs[middle]) / 2.0;
  //   }
  // }
  // double stdDevMs = 0.0;
  // if (timeMs.length > 1) {
  //   // Need at least 2 data points for std dev
  //   final double mean = avgMs;
  //   final double sumOfSquaredDifferences = timeMs
  //       .map((x) => math.pow(x - mean, 2))
  //       .reduce((a, b) => a + b)
  //       .toDouble();
  //   final double variance =
  //       sumOfSquaredDifferences /
  //       (timeMs.length - 1); // Sample standard deviation
  //   stdDevMs = math.sqrt(variance);
  // } else if (timeMs.length == 1) {
  //   stdDevMs = 0.0; // Standard deviation is 0 for a single data point
  // }
  // print("test stats for $description - iterations:$iterations");
  // print(" - total: $sumMs");
  // print(" - avg: $avgMs");
  // print(" - median: $medianMs");
  // print(" - min: $minMs");
  // print(" - max: $maxMs");
  // print(" - std: $stdDevMs");
  return results;
}
