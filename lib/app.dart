import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/tokens.dart';
import 'screens/onboarding_screen.dart';
import 'screens/shell.dart';
import 'state/app_state.dart';

class AsvabCoachApp extends StatelessWidget {
  const AsvabCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.select<AppState, bool>((s) => s.darkMode);
    final loading = context.select<AppState, bool>((s) => s.loading);
    final onboarded = context.select<AppState, bool>((s) => s.onboarded);

    return MaterialApp(
      title: 'ASVAB Coach - Army National Guard',
      debugShowCheckedModeBanner: false,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.build(Brightness.light),
      darkTheme: AppTheme.build(Brightness.dark),
      home: loading
          ? const _BootScreen()
          : (onboarded ? const RootShell() : const OnboardingScreen()),
    );
  }
}

class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: c.primarySoft,
                borderRadius: BorderRadius.circular(Radii.lg),
              ),
              child: Icon(Icons.shield_outlined, color: c.primary, size: 28),
            ),
            const SizedBox(height: Space.lg),
            SizedBox(
              width: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: c.surfaceSunken,
                  color: c.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
