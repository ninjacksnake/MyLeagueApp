import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_league/main.dart';
import 'package:my_league/models/league_doc.dart';
import 'package:my_league/models/player_doc.dart';
import 'package:my_league/providers/league_provider.dart';

void main() {
  late Isar isar;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('isar_widget_test');
    isar = await Isar.open([LeagueDocSchema, PlayerDocSchema], directory: tempDir.path);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'app_deletion_password': '1234',
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isarProvider.overrideWithValue(isar),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that we start on the splash screen.
    expect(find.text('THE ULTIMATE TOURNAMENT MANAGER'), findsOneWidget);

    // Advance fake timer by 2.8 seconds to trigger the navigation.
    await tester.pump(const Duration(milliseconds: 2800));
    // Settle the fade transition animation.
    await tester.pumpAndSettle();

    // Verify that the dashboard title and empty state text are present.
    expect(find.text('MY LEAGUE'), findsOneWidget);
    expect(find.text('No Leagues Yet'), findsOneWidget);
  });
}
