import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/gen/app_localizations.dart';
import '../../../../shared/relative_time.dart';
import '../../domain/entities/today_entity.dart';

/// "Bugün"ün ilk bölümü (karar 0002): kim yazdı, ne zaman, not. Uzun not 4 satırda kesilir ve genişletilebilir.
class DietitianNoteCard extends StatefulWidget {
  const DietitianNoteCard({super.key, required this.note, this.now});
  final DietitianNoteEntity note;

  /// Testlerde sabit "şimdi".
  final DateTime? now;

  static const collapsedLines = 4;

  @override
  State<DietitianNoteCard> createState() => _DietitianNoteCardState();
}

class _DietitianNoteCardState extends State<DietitianNoteCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final l10n = AppLocalizations.of(context);
    final note = widget.note;
    final textStyle = dy.text(DyTextStyle.body);

    return DyCard(
      variant: DyCardVariant.raised,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: DySpacing.md,
        children: [
          Row(
            spacing: DySpacing.md,
            children: [
              DyAvatar(name: note.authorName, verified: note.authorVerified, image: note.authorAvatarUrl == null ? null : NetworkImage(note.authorAvatarUrl!)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: DySpacing.xxs,
                  children: [
                    DyText(note.authorName, style: DyTextStyle.label),
                    DyText(
                      relativeTime(l10n, note.createdAt, now: widget.now),
                      style: DyTextStyle.caption,
                      tone: DyTextTone.muted,
                    ),
                  ],
                ),
              ),
              const DySourceTag(DyDataSource.dietitian),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final painter = TextPainter(
                text: TextSpan(text: note.text, style: textStyle),
                maxLines: DietitianNoteCard.collapsedLines,
                textDirection: Directionality.of(context),
                textScaler: MediaQuery.textScalerOf(context),
              )..layout(maxWidth: constraints.maxWidth);
              final overflows = painter.didExceedMaxLines;
              painter.dispose();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSize(
                    duration: dy.duration(DyDuration.normal),
                    curve: DyEasing.standard,
                    alignment: Alignment.topCenter,
                    child: Text(
                      note.text,
                      style: textStyle,
                      maxLines: _expanded ? null : DietitianNoteCard.collapsedLines,
                      overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                  ),
                  if (overflows || _expanded)
                    Padding(
                      padding: const EdgeInsets.only(top: DySpacing.xs),
                      // Ghost butonun yatay iç boşluğu (spacing.md) kadar sola: etiket not metniyle aynı kenarda başlar.
                      child: Transform.translate(
                        offset: const Offset(-DySpacing.md, 0),
                        child: DyButton(
                          label: _expanded ? l10n.noteReadLess : l10n.noteReadMore,
                          variant: DyButtonVariant.ghost,
                          size: DyButtonSize.sm,
                          iconEnd: _expanded ? DyIcons.chevronUp : DyIcons.chevronDown,
                          onPressed: () => setState(() => _expanded = !_expanded),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
