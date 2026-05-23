import 'package:logging/logging.dart' as logging;
import 'package:stack_trace/stack_trace.dart';

final _Log logger = _Log();

enum Level {
  debug,
  info,
  warning,
  error,
  dangerous;

  logging.Level toLoggingLevel() {
    switch (this) {
      case debug:
        return logging.Level.FINEST;
      case info:
        return logging.Level.INFO;
      case warning:
        return logging.Level.WARNING;
      case error:
        return logging.Level.SEVERE;
      case dangerous:
        return logging.Level.SHOUT;
    }
  }
}

final _logger = logging.Logger('secp256k1_FFI');

class _Log {
  bool _showStackTraces = false;
  _Log();

  void log(Object? message, [Level severity = Level.error]) {
    if (!_showStackTraces) {
      return _logger.log(severity.toLoggingLevel(), message);
    }
    return _logger.log(severity.toLoggingLevel(), message, null, Trace.current(2));
  }

  void configure({bool? showStackTraces}) {
    _showStackTraces = showStackTraces??_showStackTraces;
  }
}
