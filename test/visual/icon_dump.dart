// Manual harness: renders the launcher icon at every density Android wants.
// Not picked up by 'flutter test' because the filename does not end _test.dart.
//
//   flutter test test/visual/icon_dump.dart --update-goldens
//
// The app ships no artwork, so the launcher icon is drawn here from a Material
// glyph. Nothing about it imitates an official Army or National Guard insignia.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Color brand = Color(0xFF14503F);

Future<void> _loadFonts() async {
  final exe = Platform.resolvedExecutable;
  final marker = exe.indexOf('bin');
  if (marker < 0) return;
  final base =
      '${exe.substring(0, marker)}bin${Platform.pathSeparator}cache${Platform.pathSeparator}artifacts${Platform.pathSeparator}material_fonts${Platform.pathSeparator}';
  final file = File('${base}MaterialIcons-Regular.otf');
  if (!file.existsSync()) return;
  final loader = FontLoader('MaterialIcons')
    ..addFont(
      Future<ByteData>.value(ByteData.sublistView(file.readAsBytesSync())),
    );
  await loader.load();
}

/// A shield with a check: "ready and verified", with no service insignia.
class _LauncherIcon extends StatelessWidget {
  const _LauncherIcon({required this.adaptive});

  /// Adaptive foregrounds keep the glyph inside the safe zone, because the
  /// launcher masks and can animate the outer ring. Legacy icons supply their
  /// own background, so the glyph can be a little larger.
  final bool adaptive;

  @override
  Widget build(BuildContext context) {
    final glyph = LayoutBuilder(
      builder: (context, constraints) => Icon(
        Icons.verified_user_rounded,
        size: constraints.maxWidth * (adaptive ? 0.52 : 0.60),
        color: Colors.white,
      ),
    );
    return adaptive
        ? Center(child: glyph)
        : ColoredBox(
            color: brand,
            child: Center(child: glyph),
          );
  }
}

Future<void> shoot(
  WidgetTester tester,
  String goldenPath,
  double px, {
  bool adaptive = false,
}) async {
  tester.view.physicalSize = Size(px, px);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: px,
        height: px,
        child: _LauncherIcon(adaptive: adaptive),
      ),
    ),
  );
  await tester.pump();
  await expectLater(find.byType(SizedBox).first, matchesGoldenFile(goldenPath));
}

void main() {
  setUpAll(_loadFonts);

  // Legacy launcher icons, one per density bucket.
  const legacy = <String, double>{
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
  };

  // Adaptive foregrounds are 108dp at every density.
  const foreground = <String, double>{
    'mdpi': 108,
    'hdpi': 162,
    'xhdpi': 216,
    'xxhdpi': 324,
    'xxxhdpi': 432,
  };

  for (final entry in legacy.entries) {
    testWidgets('legacy ${entry.key}', (tester) async {
      await shoot(
        tester,
        '../../android/app/src/main/res/mipmap-${entry.key}/ic_launcher.png',
        entry.value,
      );
    });
  }

  for (final entry in foreground.entries) {
    testWidgets('foreground ${entry.key}', (tester) async {
      await shoot(
        tester,
        '../../android/app/src/main/res/mipmap-${entry.key}/ic_launcher_foreground.png',
        entry.value,
        adaptive: true,
      );
    });
  }
}
