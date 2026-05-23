import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart' as testing;

import 'grill_test_result.dart';
import 'humanize_time.dart';

GrillTestResult testBenchmark(
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
  Stopwatch watch = Stopwatch();
  GrillTestResult results = GrillTestResult();
  results.runTime = List.filled(iterations, 0.0);
  for (int i = 0; i < iterations; i++) {
    watch.start();
    body();
    watch.stop();
    results.runTime[i] = watch.elapsedTicks/watch.frequency;
    watch.reset();
  }
  List<double> timeMs = results.runTime.map<double>((d) => d*1000).toList();
  final double sumMs = timeMs.reduce((a, b) => a + b);
  final double avgMs = timeMs.isEmpty ? 0.0 : sumMs / timeMs.length;
  final double minMs = timeMs.isEmpty ? 0 : timeMs.reduce((a, b) => a < b ? a : b);
  final double maxMs = timeMs.isEmpty ? 0 : timeMs.reduce((a, b) => a > b ? a : b);
  double medianMs = 0.0;
  if (timeMs.isNotEmpty) {
    // Create a mutable copy to sort
    final List<double> sortedTimeMs = List<double>.from(timeMs)..sort();
    final int middle = sortedTimeMs.length ~/ 2; // Integer division

    if (sortedTimeMs.length % 2 == 1) {
      // Odd number of elements: median is the middle element
      medianMs = sortedTimeMs[middle].toDouble();
    } else {
      // Even number of elements: median is the average of the two middle elements
      medianMs = (sortedTimeMs[middle - 1] + sortedTimeMs[middle]) / 2.0;
    }
  }
  double stdDevMs = 0.0;
  if (timeMs.length > 1) {
    // Need at least 2 data points for std dev
    final double mean = avgMs;
    final double sumOfSquaredDifferences = timeMs
        .map((x) => math.pow(x - mean, 2))
        .reduce((a, b) => a + b)
        .toDouble();
    final double variance =
        sumOfSquaredDifferences /
        (timeMs.length - 1); // Sample standard deviation
    stdDevMs = math.sqrt(variance);
  } else if (timeMs.length == 1) {
    stdDevMs = 0.0; // Standard deviation is 0 for a single data point
  }
  print("test stats for $description - iterations:$iterations");
  print(" - total: ${humanizeTime(sumMs)}");
  print(" - avg: ${humanizeTime(avgMs)}");
  print(" - median: ${humanizeTime(medianMs)}");
  print(" - min: ${humanizeTime(minMs)}");
  print(" - max: ${humanizeTime(maxMs)}");
  print(" - std: ${humanizeTime(stdDevMs)}");
  return results;
}
