// Driver entry point so the on-device test can also be run with 'flutter drive',
// which accepts a pre-built binary and therefore needs no Gradle at run time:
//
//   flutter drive \
//     --driver=test_driver/integration_test.dart \
//     --target=integration_test/journey_test.dart \
//     -d <device-id> \
//     --use-application-binary=build/app/outputs/flutter-apk/app-debug.apk
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
