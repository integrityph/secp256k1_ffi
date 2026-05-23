String humanizeTime(double milliseconds) {
  if (milliseconds.isNaN) {
    return 'Invalid Time';
  }

  // Handle zero explicitly
  if (milliseconds == 0.0) {
    return '0.00 ms';
  }

  // Use absolute value for calculations, append sign later if needed
  final absMilliseconds = milliseconds.abs();
  String unit;
  double value;

  // Determine the appropriate unit and convert the value
  if (absMilliseconds >= 1000.0) {
    // Seconds (>= 1 second)
    value = absMilliseconds / 1000.0;
    unit = 's';
  } else if (absMilliseconds >= 1.0) {
    // Milliseconds (1 ms to < 1000 ms)
    value = absMilliseconds;
    unit = 'ms';
  } else if (absMilliseconds >= 0.001) {
    // Microseconds (1 µs to < 1 ms)
    value = absMilliseconds * 1000.0;
    unit = 'µs'; // Using micro sign
  } else {
    // Nanoseconds (0 ns to < 1 µs)
    value = absMilliseconds * 1000000.0;
    unit = 'ns';
  }

  // Format to two decimal places
  final formattedValue = value.toStringAsFixed(2);

  // Prepend minus sign if original value was negative
  final sign = milliseconds < 0 ? '-' : '';

  return '$sign$formattedValue $unit';
}