import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/tokens.dart';
import '../data/models/mos.dart';
import '../data/models/score.dart';
import '../engines/recruiter_sheet.dart';
import '../widgets/primitives.dart';

/// The recruiter export (ROADMAP Phase 4: "walk into the office prepared").
///
/// One page a candidate can read on the phone and copy: the AFQT figures, every
/// aptitude-area score, every job the scores clear and the jobs they are close
/// to. The page renders [RecruiterSheet.sections], so it cannot say anything the
/// formatter does not already say, and every number on it keeps its one source.
///
/// It is deliberately a plain text page rather than a designed report. The text
/// is the artefact: what a candidate copies is exactly what they saw, and
/// nothing leaves the device to produce it. No file is written, no share sheet
/// is opened, nothing is printed and no plugin or platform channel is involved -
/// the clipboard is part of Flutter itself.
///
/// The screen is given everything it prints, including the date, so it reads no
/// clock and no storage and a test can pin the whole page.
class RecruiterSheetScreen extends StatelessWidget {
  const RecruiterSheetScreen({
    super.key,
    required this.report,
    required this.jobs,
    required this.generatedOn,
    this.candidateName,
  });

  /// The finished attempt the sheet is built from. Null before the first
  /// attempt, which the page says out loud rather than drawing an empty sheet.
  final ScoreReport? report;

  /// The catalogue to measure [report] against. Empty when the repository has
  /// nothing loaded, which is a defect in the app rather than a fact about the
  /// candidate - so it gets its own sentence instead of a page that would claim
  /// they qualify for no jobs at all.
  final List<Mos> jobs;

  /// The date printed on the sheet. Supplied by the caller, because the
  /// formatter never reads the clock.
  final DateTime generatedOn;

  final String? candidateName;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final report = this.report;
    final sections = report == null || jobs.isEmpty
        ? null
        : RecruiterSheet.sections(
            report: report,
            jobs: jobs,
            generatedOn: generatedOn,
            candidateName: candidateName,
          );
    final sheetText = sections == null ? null : RecruiterSheet.toText(sections);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recruiter sheet'),
        actions: <Widget>[
          // Only offered when there is a page to copy: a button that silently
          // copies nothing is worse than no button.
          if (sheetText != null)
            IconButton(
              onPressed: () => _copy(context, sheetText),
              tooltip: 'Copy sheet text',
              icon: const Icon(Icons.copy_all_rounded),
            ),
          const SizedBox(width: Space.sm),
        ],
      ),
      body: PageBody(
        maxWidth: 640,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'One page of your scores and the jobs they open, ready to hand to '
              'a recruiter.',
              style: context.text.bodyMedium?.copyWith(color: c.textMuted),
            ),
            const SizedBox(height: Space.lg),
            if (report == null)
              const EmptyState(
                icon: Icons.description_outlined,
                title: 'No sheet to hand over yet',
                body:
                    'This page is built from a finished attempt, and there is '
                    'not one on this device yet. Take the diagnostic or a '
                    'practice test and your scores, line scores and jobs appear '
                    'here, ready to copy.',
              )
            else if (sections == null)
              const EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'The job list is empty',
                body:
                    'The sheet classifies every job in the catalogue against '
                    'your scores, and the catalogue is not loaded, so there is '
                    'nothing honest to print. A page that silently left out '
                    'every job you meet would be worse than no page at all.',
              )
            else ...<Widget>[
              const Callout(
                tone: PillTone.warning,
                icon: Icons.info_outline_rounded,
                title: 'An estimate, not an official record',
                text:
                    'Everything on this page is calculated here, on this '
                    'device, from the practice questions you answered, so it '
                    'carries no official standing. Only the test you take at a '
                    'Military Entrance Processing Station or an approved test '
                    'site produces official ASVAB scores.',
              ),
              const SizedBox(height: Space.lg),
              // The sheet itself, on a card so it reads as one document on a
              // page rather than as the app's own words.
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: Space.lg,
                  vertical: Space.lg,
                ),
                child: _SheetText(sections: sections),
              ),
              const SizedBox(height: Space.lg),
              FilledButton.icon(
                onPressed: () => _copy(context, sheetText!),
                icon: const Icon(Icons.copy_all_rounded, size: 18),
                label: const Text('Copy sheet'),
              ),
              const SizedBox(height: Space.sm),
              Text(
                'Every line is wrapped to '
                '${RecruiterSheet.defaultWidth} characters, so the page pastes '
                'into a message or an email with its columns intact.',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: Space.xl),
            ],
          ],
        ),
      ),
    );
  }

  /// Puts the whole page on the clipboard and says so.
  ///
  /// [Clipboard] is part of the Flutter framework, so this needs no plugin, no
  /// permission and no platform channel of our own - and the copy is the same
  /// string the screen renders, so what a candidate pastes is what they read.
  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Sheet copied. Paste it wherever you need it.'),
        ),
      );
  }
}

/// One rendered line: already wrapped by the formatter, and flagged when it is
/// a section heading rather than body text.
class _SheetLine {
  const _SheetLine(this.text, {this.isHeading = false});

  final String text;
  final bool isHeading;
}

/// The page as a monospace grid.
///
/// The formatter has already wrapped every line to [RecruiterSheet.defaultWidth]
/// characters, so the sheet is a fixed 46-column block and its alignment - a
/// code beside its title, a figure under its label - is part of what it means.
/// That alignment survives only if nothing re-lays the text out, which shapes
/// the whole widget:
///
///  * one [Text] per line, never one [Text] per paragraph, and 'softWrap' off
///    so the framework cannot re-wrap a line the formatter deliberately placed;
///  * a monospace face, so every column starts where the previous line's did;
///  * the largest size that fits the width available, measured rather than
///    guessed - a phone then shows all 46 columns without the candidate having
///    to scroll sideways to read a line;
///  * a readable floor with a horizontal scroll beneath it (very narrow screen,
///    large system text), because a shrunken page nobody can read is not a
///    readable page either.
///
/// The system text scale is deliberately not applied to the block. This is a
/// preformatted document, and scaling multiplies the size of the widest line,
/// which is the one thing that cannot grow without breaking the grid; the page
/// is fitted to the width instead. The words around it - title, callout, button,
/// caption - scale normally, so the screen still honours the setting.
class _SheetText extends StatelessWidget {
  const _SheetText({required this.sections});

  final List<RecruiterSheetSection> sections;

  /// The lines in reading order, headings flagged, with one blank line between
  /// sections - the same shape [RecruiterSheet.toText] joins with.
  List<_SheetLine> get _lines {
    final lines = <_SheetLine>[];
    for (final section in sections) {
      if (section.isEmpty) continue;
      if (lines.isNotEmpty) lines.add(const _SheetLine(''));
      final heading = section.heading;
      if (heading != null && heading.isNotEmpty) {
        lines.add(_SheetLine(heading, isHeading: true));
      }
      for (final line in section.lines) {
        lines.add(_SheetLine(line));
      }
    }
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final lines = _lines;

    TextStyle styleAt(double fontSize, {required bool isHeading}) => TextStyle(
      fontFamily: 'monospace',
      fontFamilyFallback: _monospaceFallbacks,
      fontSize: fontSize,
      height: 1.4,
      letterSpacing: 0,
      fontWeight: isHeading ? FontWeight.w700 : FontWeight.w400,
      color: isHeading ? c.textPrimary : c.textSecondary,
    );

    /// The width the widest line needs at [fontSize], measured with the same
    /// face and scale the line is painted with.
    double widestAt(double fontSize) {
      var widest = 0.0;
      for (final line in lines) {
        if (line.text.isEmpty) continue;
        final painter = TextPainter(
          text: TextSpan(
            text: line.text,
            style: styleAt(fontSize, isHeading: line.isHeading),
          ),
          textDirection: TextDirection.ltr,
          textScaler: TextScaler.noScaling,
          maxLines: 1,
        )..layout();
        widest = math.max(widest, painter.width);
        painter.dispose();
      }
      return widest;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : _sheetPageWidth;
        final natural = widestAt(_sheetMaxFontSize);
        final fit = natural <= 0
            ? _sheetMaxFontSize
            : _sheetMaxFontSize * available / natural;
        final fontSize = fit.clamp(_sheetMinFontSize, _sheetMaxFontSize);
        final needed = fontSize >= _sheetMaxFontSize
            ? natural
            : widestAt(fontSize);

        final block = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (final line in lines)
              Text(
                // A blank row has no glyphs to measure, so it is given a space
                // to keep its full line height in the grid.
                line.text.isEmpty ? ' ' : line.text,
                style: styleAt(fontSize, isHeading: line.isHeading),
                softWrap: false,
              ),
          ],
        );

        // Below the floor the grid needs more room than the card has. Scrolling
        // is the least bad answer: the alternative is a clipped column or a
        // font size nobody can read.
        if (needed <= available + 0.5) return block;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: block,
        );
      },
    );
  }
}

/// Monospace faces to try, best first. Every platform this app ships to has at
/// least one, so no font file is bundled to say what the system already says.
const List<String> _monospaceFallbacks = <String>[
  'monospace',
  'Roboto Mono',
  'Courier New',
  'Courier',
  'Consolas',
  'Menlo',
];

/// The size the sheet is laid out at when there is room for all 46 columns, and
/// the floor below which it stops shrinking and starts scrolling instead.
const double _sheetMaxFontSize = 13;
const double _sheetMinFontSize = 10;

/// Where the sheet is laid out when the width is unbounded, which only happens
/// in the horizontal scroll fallback.
const double _sheetPageWidth = 320;
