import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import 'dashboard_screen.dart';
import 'jobs_screen.dart';
import 'plan_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';
import 'test_center_screen.dart';

/// The responsive app shell: a bottom bar on phones, a rail on desktop.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _destinations = <_Destination>[
    _Destination(
      'Home',
      Icons.space_dashboard_outlined,
      Icons.space_dashboard_rounded,
    ),
    _Destination(
      'Plan',
      Icons.auto_stories_outlined,
      Icons.auto_stories_rounded,
    ),
    _Destination('Test', Icons.timer_outlined, Icons.timer_rounded),
    _Destination('Jobs', Icons.workspaces_outline, Icons.workspaces_rounded),
    _Destination('Progress', Icons.insights_outlined, Icons.insights_rounded),
  ];

  void _go(int i) {
    if (i == _index) return;
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final expanded = context.isMediumUp;
    final pages = <Widget>[
      DashboardScreen(onNavigate: _go),
      const PlanScreen(),
      const TestCenterScreen(),
      const JobsScreen(),
      const ProgressScreen(),
    ];

    final body = IndexedStack(index: _index, children: pages);

    if (expanded) {
      return Scaffold(
        body: Row(
          children: <Widget>[
            _Rail(index: _index, onSelect: _go, destinations: _destinations),
            VerticalDivider(width: 1, color: c.border),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: c.surface,
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: <Widget>[
                for (var i = 0; i < _destinations.length; i++)
                  Expanded(
                    child: _BottomTab(
                      destination: _destinations[i],
                      selected: i == _index,
                      onTap: () => _go(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.icon, this.activeIcon);
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _BottomTab extends StatelessWidget {
  const _BottomTab({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _Destination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.primary : c.textMuted;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedContainer(
            duration: Motion.fast,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: selected ? c.primarySoft : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(
              selected ? destination.activeIcon : destination.icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            destination.label,
            style: context.text.labelSmall?.copyWith(
              color: color,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({
    required this.index,
    required this.onSelect,
    required this.destinations,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final List<_Destination> destinations;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 232,
      color: c.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.lg,
                Space.xl,
                Space.lg,
                Space.lg,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: c.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      size: 18,
                      color: c.onPrimary,
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'ASVAB Coach',
                          style: context.text.titleSmall?.copyWith(
                            color: c.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Army National Guard',
                          style: context.text.bodySmall?.copyWith(
                            color: c.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.xs),
            for (var i = 0; i < destinations.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Space.md,
                  vertical: 2,
                ),
                child: _RailItem(
                  destination: destinations[i],
                  selected: i == index,
                  onTap: () => onSelect(i),
                ),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Space.md,
                vertical: Space.md,
              ),
              child: _RailItem(
                destination: const _Destination(
                  'Settings',
                  Icons.settings_outlined,
                  Icons.settings_rounded,
                ),
                selected: false,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Space.sm),
          ],
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _Destination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.md),
        child: AnimatedContainer(
          duration: Motion.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: Space.md,
            vertical: Space.md,
          ),
          decoration: BoxDecoration(
            color: selected ? c.primarySoft : Colors.transparent,
            borderRadius: BorderRadius.circular(Radii.md),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                selected ? destination.activeIcon : destination.icon,
                size: 19,
                color: selected ? c.primary : c.textMuted,
              ),
              const SizedBox(width: Space.md),
              Text(
                destination.label,
                style: context.text.titleSmall?.copyWith(
                  color: selected ? c.primary : c.textSecondary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
