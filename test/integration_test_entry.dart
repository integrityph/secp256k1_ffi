import 'package:integration_test/integration_test.dart'; // Import this
import 'package:secp256k1_ffi/src/logging/logging.dart';
import 'package:logging/logging.dart' as logging_pkg;
import '../grill_testing/grill_group.dart';
import 'tagged_hash/test_list.dart' as tagged_hash;


void startTesting([iterations=1]) {
  // Initialize the integration test binding. This is crucial!
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Configure your internal logger for integration tests if needed
  logging_pkg.Logger.root.level = logging_pkg.Level.ALL;
  logging_pkg.Logger.root.onRecord.listen((record) {
    if (record.level != logging_pkg.Level.FINEST && record.level != logging_pkg.Level.FINE) {
      // ignore: avoid_print
      print('[INTEGRATION_LOG] ${record.level.name}: ${record.message}');
    }
  });
  logger.configure(showStackTraces: true); // Enable stack traces for integration test logs

  final List<Function()> testList = [
    ...tagged_hash.testList,
  ];

  group('secp256k1 FFI Integration Tests', () {
    for (final testFunc in testList) {
        testFunc();
    }
    // You would add groups for other modules (AES, RSA, etc.) here as well.
  });
}
