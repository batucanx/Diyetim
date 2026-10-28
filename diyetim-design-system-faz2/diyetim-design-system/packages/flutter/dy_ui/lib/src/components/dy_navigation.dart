import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../i18n_strings.dart';
import '../primitives/dy_icon.dart';
import '../primitives/dy_pressable.dart';
import '../theme/dy_context.dart';
import 'dy_button.dart';
import 'dy_feedback.dart';

/// Üst çubuk: geri butonu, başlık, eylemler. [large] ana sekmelerde büyük başlık.
class DyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DyAppBar({super.key, required this.title, this.onBack, this.backLabel, this.actions = const [], this.large = false, this.bordered = true});
  final String title;
  final VoidCallback? onBack;
  final String? backLabel;
  final List<Widget> actions;
  final bool large;
  final bool bordered;

  @override
  Size get preferredSize => Size.fromHeight(large ? DySize.appBar + DySpacing.xl3 : DySize.appBar);

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final back = onBack == null ? null : DyIconButton(icon: DyIcons.chevronLeft, label: backLabel ?? 'Geri', onPressed: onBack);
    final bar = SizedBox(
      height: DySize.appBar,
      child: Row(children: [
        if (back != null) back else const SizedBox(width: DySpacing.lg),
        Expanded(
          child: large
              ? const SizedBox.shrink()
              : Semantics(header: true, child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: back == null ? TextAlign.start : TextAlign.center, style: dy.text(DyTextStyle.h4).copyWith(fontWeight: FontWeight.w700))),
        ),
        ...actions,
        const SizedBox(width: DySpacing.xs),
      ]),
    );
    return Material(
      color: dy.colors.background,
      child: SafeArea(
        bottom: false,
        child: DecoratedBox(
          decoration: BoxDecoration(border: bordered ? Border(bottom: BorderSide(color: dy.colors.borderSubtle, width: DyBorderWidth.widthHairline)) : null),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            bar,
            if (large)
              Padding(
                padding: const EdgeInsets.fromLTRB(DySpacing.xl, 0, DySpacing.xl, DySpacing.md),
                child: Semantics(header: true, child: Text(title, style: dy.text(DyTextStyle.h1))),
              ),
          ]),
        ),
      ),
    );
  }
}

@immutable
class DyNavDestination {
  const DyNavDestination({required this.label, required this.icon, this.badge = 0, this.badgeLabel});
  final String label;
  final DyIconData icon;
  final int badge;
  final String? badgeLabel;
}

/// Danışan uygulamasının ana gezinmesi: yüzen kapsül, 4 hedef + opsiyonel orta eylem (öğün fotoğrafı).
class DyBottomNavigation extends StatelessWidget {
  const DyBottomNavigation({super.key, required this.destinations, required this.selectedIndex, required this.onSelected, this.centerAction, this.centerActionLabel, this.onCenterAction});
  final List<DyNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final DyIconData? centerAction;
  final String? centerActionLabel;
  final VoidCallback? onCenterAction;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    Widget item(int i) {
      final d = destinations[i];
      final on = i == selectedIndex;
      return Expanded(
        child: DyPressable(
          onPressed: () => onSelected(i),
          button: false,
          selected: on,
          semanticLabel: d.badge > 0 && d.badgeLabel != null ? '${d.label}, ${d.badgeLabel}' : d.label,
          pressScale: 0.96,
          borderRadius: BorderRadius.circular(DyRadius.md),
          minSize: const Size(DySize.targetComfortable, DySize.targetComfortable),
          builder: (context, s) => Column(mainAxisSize: MainAxisSize.min, spacing: DySpacing.xxs, children: [
            Stack(clipBehavior: Clip.none, children: [
              DyIcon(d.icon, size: DyIconSize.lg, color: on ? c.primary : c.textMuted),
              if (d.badge > 0) Positioned(top: -DySpacing.xs, right: -DySpacing.md, child: ExcludeSemantics(child: DyBadge(count: d.badge, label: d.badgeLabel ?? '${d.badge}', tone: DyBadgeTone.error))),
            ]),
            Text(d.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: dy.text(DyTextStyle.caption, tone: on ? DyTextTone.primary : DyTextTone.muted).copyWith(fontWeight: FontWeight.w600)),
          ]),
        ),
      );
    }

    final half = (destinations.length / 2).ceil();
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(DySpacing.md, 0, DySpacing.md, DySpacing.md),
        child: Container(
          constraints: const BoxConstraints(minHeight: DySize.navBottom),
          padding: const EdgeInsets.symmetric(horizontal: DySpacing.sm, vertical: DySpacing.xs),
          decoration: BoxDecoration(
            color: c.surfaceElevated,
            borderRadius: BorderRadius.circular(DyRadius.full),
            border: Border.all(color: dy.isDark ? Color.alphaBlend(dy.shadows.edgeHighlight, c.borderSubtle) : c.borderSubtle, width: DyBorderWidth.widthHairline),
            boxShadow: dy.shadows.high,
          ),
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            child: Row(children: [
              for (var i = 0; i < (centerAction != null ? half : destinations.length); i++) item(i),
              if (centerAction != null)
                DyPressable(
                  onPressed: onCenterAction,
                  semanticLabel: centerActionLabel,
                  borderRadius: BorderRadius.circular(DyRadius.full),
                  builder: (context, s) => Container(
                    width: DySize.targetComfortable,
                    height: DySize.targetComfortable,
                    decoration: BoxDecoration(color: c.surfaceInverse, shape: BoxShape.circle),
                    child: Center(child: DyIcon(centerAction!, size: DyIconSize.lg, color: c.textOnInverse)),
                  ),
                ),
              if (centerAction != null) for (var i = half; i < destinations.length; i++) item(i),
            ]),
          ),
        ),
      ),
    );
  }
}

@immutable
class DyTab {
  const DyTab({required this.label, this.count = 0, this.countLabel, this.enabled = true});
  final String label;
  final int count;
  final String? countLabel;
  final bool enabled;
}

/// Sekmeler: aynı bağlamın bölümleri. Yatay kaydırılır; ←/→ ile geçiş; seçili sekme alt çizgiyle.
class DyTabs extends StatelessWidget {
  const DyTabs({super.key, required this.label, required this.tabs, required this.selectedIndex, required this.onSelected});
  final String label;
  final List<DyTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  void _move(int dir) {
    final enabled = [for (var i = 0; i < tabs.length; i++) if (tabs[i].enabled) i];
    final pos = enabled.indexOf(selectedIndex);
    onSelected(enabled[(pos + dir + enabled.length) % enabled.length]);
  }

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    return Semantics(
      container: true,
      label: label,
      child: CallbackShortcuts(
        bindings: {const SingleActivator(LogicalKeyboardKey.arrowRight): () => _move(1), const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _move(-1)},
        child: DecoratedBox(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.borderSubtle, width: DyBorderWidth.widthHairline))),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(spacing: DySpacing.lg, children: [
              for (var i = 0; i < tabs.length; i++)
                DyPressable(
                  onPressed: () => onSelected(i),
                  state: tabs[i].enabled ? DyComponentState.enabled : DyComponentState.disabled,
                  button: false,
                  selected: i == selectedIndex,
                  semanticLabel: tabs[i].count > 0 && tabs[i].countLabel != null ? '${tabs[i].label}, ${tabs[i].countLabel}' : tabs[i].label,
                  pressScale: 1,
                  borderRadius: BorderRadius.circular(DyRadius.sm),
                  builder: (context, s) => Container(
                    padding: const EdgeInsets.symmetric(vertical: DySpacing.sm, horizontal: DySpacing.xxs),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: i == selectedIndex ? c.primary : const Color(0x00000000), width: DySpacing.xxs))),
                    child: Row(mainAxisSize: MainAxisSize.min, spacing: DySpacing.xs, children: [
                      Text(tabs[i].label, style: dy.text(DyTextStyle.body, tone: i == selectedIndex ? DyTextTone.primary : DyTextTone.secondary).copyWith(fontWeight: i == selectedIndex ? FontWeight.w700 : FontWeight.w600)),
                      if (tabs[i].count > 0) ExcludeSemantics(child: DyBadge(count: tabs[i].count, label: tabs[i].countLabel ?? '', tone: i == selectedIndex ? DyBadgeTone.primary : DyBadgeTone.neutral)),
                    ]),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Modal pencere. Mobilde Diyetim dilinde ortalanmış kart; uzun içerik kaydırılır.
abstract final class DyDialog {
  static Future<T?> show<T>(BuildContext context, {required String title, String? description, Widget? body, List<Widget> actions = const [], bool dismissible = true}) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      barrierColor: context.dy.colors.scrim,
      builder: (context) => _DialogCard(title: title, description: description, body: body, actions: actions),
    );
  }

  /// Onay penceresi. Yıkıcı onaylarda ilk odak "Vazgeç"te. Sonuç: true (onay) / false·null (vazgeç).
  static Future<bool?> confirm(BuildContext context, {required String title, required String description, required String confirmLabel, String cancelLabel = 'Vazgeç', bool destructive = false}) {
    return show<bool>(context, title: title, description: description, actions: [
      Builder(builder: (context) => DyButton(label: cancelLabel, variant: DyButtonVariant.tertiary, onPressed: () => Navigator.of(context).pop(false))),
      Builder(builder: (context) => DyButton(label: confirmLabel, variant: destructive ? DyButtonVariant.destructive : DyButtonVariant.primary, onPressed: () => Navigator.of(context).pop(true))),
    ]);
  }
}

class _DialogCard extends StatelessWidget {
  const _DialogCard({required this.title, required this.description, required this.body, required this.actions});
  final String title;
  final String? description;
  final Widget? body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    return Dialog(
      backgroundColor: dy.colors.surfaceElevated,
      surfaceTintColor: const Color(0x00000000),
      insetPadding: const EdgeInsets.all(DySpacing.xl),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DyRadius.xl)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DySize.sidebar * 2),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DySpacing.xl2),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, spacing: DySpacing.md, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Padding(padding: const EdgeInsets.only(top: DySpacing.sm), child: Semantics(header: true, child: Text(title, style: dy.text(DyTextStyle.h3))))),
              DyIconButton(icon: DyIcons.x, label: DyStrings.of(context).t('common.close'), onPressed: () => Navigator.of(context).maybePop()),
            ]),
            if (description != null) Text(description!, style: dy.text(DyTextStyle.body, tone: DyTextTone.secondary)),
            if (body != null) body!,
            if (actions.isNotEmpty) Padding(padding: const EdgeInsets.only(top: DySpacing.sm), child: Wrap(alignment: WrapAlignment.end, spacing: DySpacing.sm, runSpacing: DySpacing.sm, children: actions)),
          ]),
        ),
      ),
    );
  }
}

/// Alttan açılan sayfa: başlık, içerik, opsiyonel birincil eylem. Sürükleme tutamacı ve güvenli alan.
abstract final class DyBottomSheet {
  static Future<T?> show<T>(BuildContext context, {required String title, required Widget body, Widget? action}) {
    final dy = context.dy;
    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      barrierColor: dy.colors.scrim,
      backgroundColor: dy.colors.surfaceElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(DyRadius.xl2))),
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(DySpacing.xl, 0, DySpacing.xl, DySpacing.xl + MediaQuery.viewInsetsOf(context).bottom),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, spacing: DySpacing.lg, children: [
            Semantics(header: true, child: Text(title, style: context.dy.text(DyTextStyle.h3))),
            Flexible(child: SingleChildScrollView(child: body)),
            if (action != null) action,
          ]),
        ),
      ),
    );
  }
}

@immutable
class DyMenuEntry {
  const DyMenuEntry({required this.label, required this.onSelected, this.icon, this.destructive = false, this.enabled = true});
  final String label;
  final VoidCallback onSelected;
  final DyIconData? icon;
  final bool destructive;
  final bool enabled;
}

/// Eylem menüsü: Material MenuAnchor üzerine Diyetim görünümü (klavye ve semantik MenuAnchor'dan gelir).
class DyMenu extends StatelessWidget {
  const DyMenu({super.key, required this.entries, required this.builder});
  final List<DyMenuEntry> entries;

  /// Tetikleyici: `(context, controller) => DyIconButton(..., onPressed: () => controller.isOpen ? controller.close() : controller.open())`
  final Widget Function(BuildContext context, MenuController controller) builder;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(c.surfaceElevated),
        surfaceTintColor: const WidgetStatePropertyAll(Color(0x00000000)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(DyRadius.md), side: BorderSide(color: c.borderSubtle, width: DyBorderWidth.widthHairline))),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(DySpacing.xs)),
        elevation: const WidgetStatePropertyAll(0),
      ),
      menuChildren: [
        for (final e in entries)
          MenuItemButton(
            onPressed: e.enabled ? e.onSelected : null,
            leadingIcon: e.icon == null ? null : DyIcon(e.icon!, size: DyIconSize.sm, color: e.destructive ? c.errorStrong : c.textPrimary),
            style: ButtonStyle(
              minimumSize: const WidgetStatePropertyAll(Size(DySize.sidebar * 0.8, DySize.targetMin)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(DyRadius.sm))),
              backgroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.focused) || s.contains(WidgetState.hovered) ? c.surfaceSecondary : null),
              overlayColor: const WidgetStatePropertyAll(Color(0x00000000)),
            ),
            child: Text(e.label, style: dy.text(DyTextStyle.body).copyWith(color: e.destructive ? c.errorStrong : null)),
          ),
      ],
      builder: (context, controller, _) => builder(context, controller),
    );
  }
}

/// Modal olmayan açılır panel (filtre, hızlı form). Dışarı dokunma ve Escape kapatır.
class DyPopover extends StatelessWidget {
  const DyPopover({super.key, required this.content, required this.builder});
  final Widget Function(BuildContext context, VoidCallback close) content;
  final Widget Function(BuildContext context, MenuController controller) builder;

  @override
  Widget build(BuildContext context) {
    final c = context.dy.colors;
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(c.surfaceElevated),
        surfaceTintColor: const WidgetStatePropertyAll(Color(0x00000000)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(DyRadius.md), side: BorderSide(color: c.borderSubtle, width: DyBorderWidth.widthHairline))),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(DySpacing.lg)),
        elevation: const WidgetStatePropertyAll(0),
      ),
      menuChildren: [
        Builder(builder: (context) => ConstrainedBox(constraints: const BoxConstraints(maxWidth: DySize.sidebar * 1.2), child: content(context, () => MenuController.maybeOf(context)?.close()))),
      ],
      builder: (context, controller, _) => builder(context, controller),
    );
  }
}
