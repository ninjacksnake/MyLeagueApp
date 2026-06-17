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
import 'package:my_league/screens/password_setup_screen.dart';
import 'package:my_league/screens/dashboard_screen.dart';

void main() {
  late Isar isar;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('isar_password_test');
    isar = await Isar.open([LeagueDocSchema, PlayerDocSchema], directory: tempDir.path);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('Splash routes to PasswordSetupScreen when no password exists', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

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

    // Verify starting on splash screen.
    expect(find.byType(PasswordSetupScreen), findsNothing);

    // Advance timer to trigger transition.
    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pumpAndSettle();

    // Verify redirection to PasswordSetupScreen.
    expect(find.byType(PasswordSetupScreen), findsOneWidget);
  });

  testWidgets('Splash routes directly to DashboardScreen when password exists', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'app_deletion_password': 'my_secure_password',
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

    // Verify starting on splash screen.
    expect(find.byType(DashboardScreen), findsNothing);

    // Advance timer to trigger transition.
    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pumpAndSettle();

    // Verify redirection directly to DashboardScreen.
    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('PasswordSetupScreen validates inputs and stores password', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isarProvider.overrideWithValue(isar),
        ],
        child: const MaterialApp(
          home: PasswordSetupScreen(),
        ),
      ),
    );

    // Tap submit on empty inputs.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Should trigger empty error validations.
    expect(find.text('Password cannot be empty'), findsNWidgets(2));

    // Enter mismatched passwords.
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.first, '1234');
    await tester.enterText(textFields.last, '5678');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Should trigger mismatch validation error.
    expect(find.text('Passwords do not match'), findsOneWidget);

    // Enter matching passwords.
    await tester.enterText(textFields.last, '1234');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify routing transitions to DashboardScreen.
    expect(find.byType(DashboardScreen), findsOneWidget);

    // Verify password persisted in SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app_deletion_password'), '1234');
  });
}
