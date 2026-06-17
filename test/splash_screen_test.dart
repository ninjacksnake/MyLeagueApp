import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_league/models/league_doc.dart';
import 'package:my_league/models/player_doc.dart';
import 'package:my_league/providers/league_provider.dart';
import 'package:my_league/screens/splash_screen.dart';
import 'package:my_league/screens/dashboard_screen.dart';

void main() {
  late Isar isar;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('isar_splash_test');
    isar = await Isar.open([LeagueDocSchema, PlayerDocSchema], directory: tempDir.path);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('SplashScreen renders branding and navigates to DashboardScreen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'app_deletion_password': '1234',
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isarProvider.overrideWithValue(isar),
        ],
        child: const MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    // Verify presence of splash screen text and circular indicator.
    expect(find.text('MY LEAGUE'), findsOneWidget);
    expect(find.text('THE ULTIMATE TOURNAMENT MANAGER'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verify DashboardScreen is not displayed yet.
    expect(find.byType(DashboardScreen), findsNothing);

    // Advance fake timer by 2.8 seconds to trigger navigation.
    await tester.pump(const Duration(milliseconds: 2800));
    // Settle transition animations.
    await tester.pumpAndSettle();

    // Verify that the navigation was successful and we are now on DashboardScreen.
    expect(find.byType(DashboardScreen), findsOneWidget);
  });
}
