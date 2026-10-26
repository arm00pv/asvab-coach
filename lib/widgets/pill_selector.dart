import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import '../data/repos/mos_repository.dart';

/// A searchable, grouped MOS picker used during onboarding.
class MosPicker extends StatefulWidget {
  const MosPicker({super.key, required this.selected, required this.onToggle});

  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  State<MosPicker> createState() => _MosPickerState();
}

class _MosPickerState extends State<MosPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final results = MosRepository.search(_query);
    return Column(
      children: <Widget>[
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search jobs, e.g. medic, 68W, signal',
            prefixIcon: Icon(Icons.search_rounded, size: 18),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: Space.md),
        Expanded(
          child: results.isEmpty
              ? Center(
                  child: Text(
                    'No job matches that search',
                    style: context.text.bodySmall?.copyWith(color: c.textMuted),
                  ),
                )
              : ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: Space.sm),
                  itemBuilder: (context, i) {
                    final m = results[i];
                    final on = widget.selected.contains(m.code);
                    final limitReached = widget.selected.length >= 3 && !on;
                    return Opacity(
                      opacity: limitReached ? 0.45 : 1,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(Radii.md),
                        onTap: limitReached
                            ? null
                            : () => widget.onToggle(m.code),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Space.md,
                            vertical: Space.sm,
                          ),
                          decoration: BoxDecoration(
                            color: on ? c.primarySoft : c.surface,
                            borderRadius: BorderRadius.circular(Radii.md),
                            border: Border.all(
                              color: on ? c.primary : c.border,
                              width: on ? 1.6 : 1,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 44,
                                child: Text(
                                  m.code,
                                  style: context.text.labelMedium?.copyWith(
                                    color: on ? c.primary : c.textMuted,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      m.title,
                                      style: context.text.bodyMedium?.copyWith(
                                        color: c.textPrimary,
                                      ),
                                    ),
                                    // A target MOS the pamphlet has rescinded is
                                    // not a target. Onboarding cannot carry the
                                    // full jobs-screen banner, but it can refuse
                                    // to look like an ordinary choice.
                                    if (m.rescindMarked)
                                      Text(
                                        m.rescindHeadline(DateTime.now())!,
                                        style: context.text.labelSmall
                                            ?.copyWith(
                                              color: m.retiredAt(DateTime.now())
                                                  ? c.danger
                                                  : c.warning,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: Space.sm),
                              Text(
                                m.gate.label,
                                style: context.text.labelSmall?.copyWith(
                                  color: c.textMuted,
                                ),
                              ),
                              if (on) ...<Widget>[
                                const SizedBox(width: Space.xs),
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 16,
                                  color: c.primary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
