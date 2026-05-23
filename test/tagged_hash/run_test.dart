import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'package:logging/logging.dart' as logging;

import 'test_list.dart';

void main() {
  logging.Logger.root.level = logging.Level.ALL;
  logging.Logger.root.onRecord.listen((record) {
    // During tests, you might want to suppress some logs or route them differently.
    // For now, just print non-debug logs, or route to a test-specific buffer.
    if (record.level != logging.Level.FINEST &&
        record.level != logging.Level.FINE) {
      print('[LOG] ${record.level.name}: ${record.message}');
    }
  });

  logger.configure(showStackTraces: true);

  for (var groupItem in testList) {
    groupItem();
  }
}