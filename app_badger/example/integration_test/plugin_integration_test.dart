import 'package:app_badger/app_badger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final String? version = await AppBadger.getPlatformVersion();
    expect(version?.isNotEmpty, true);
  });
}
