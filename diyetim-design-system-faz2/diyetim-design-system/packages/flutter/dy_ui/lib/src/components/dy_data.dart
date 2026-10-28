import 'dart:math' as math;

import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/material.dart';

import '../i18n_strings.dart';
import '../primitives/dy_icon.dart';
import '../primitives/dy_number.dart';
import '../primitives/dy_pressable.dart';
import '../primitives/dy_surface.dart';
import '../theme/dy_context.dart';
import '../utils/dy_format.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Card
// ─────────────────────────────────────────────────────────────────────────────

/// flat: kenarlıklı düz · raised: hafif gölge · hero: ana kart (radius-xl, büyük iç boşluk). React `Card variant` ile aynı.
enum DyCardVariant { flat, raised, hero }

enum DyCardPadding { compact, normal, hero }

/// Kart tabanı. [onTap] verilirse kartın tamamı tek bir buton olur; bu durumda kart içinde ikinci
/// etkileşimli öğe olmamalıdır (React'te geliştirme uyarısı, burada debug assert yerine dokümantasyon kuralı).
class DyCard extends StatelessWidget {
  const DyCard({super.key, required this.child, this.variant = DyCardVariant.flat, this.padding, this.onTap, this.selected, this.semanticLabel,
      this.state = DyComponentState.enabled, this.lockedReason});

  final Widget child;
  final DyCardVariant variant;
  final DyCardPadding? padding;
  final VoidCallback? onTap;

  /// Seçili kart (ör. onay kuyruğunda açık öğe). null: seçim kavramı yok.
  final bool? selected;

  /// Etkileşimli kartın okunacak adı. Verilmezse içerikteki metinler birleştirilir.
  final String? semanticLabel;
  final DyComponentState state;
  final String? lockedReason;

  double get _radius => variant == DyCardVariant.hero ? DyRadius.xl : DyRadius.lg;

  EdgeInsets get _padding => switch (padding ?? (variant == DyCardVariant.hero ? DyCardPadding.hero : DyCardPadding.normal)) {
        DyCardPadding.compact => const EdgeInsets.all(DySpacing.lg),
        DyCardPadding.normal => const EdgeInsets.all(DySpacing.xl),
        DyCardPadding.hero => const EdgeInsets.all(DySpacing.xl2),
      };

  @override
  Widget build(BuildContext context) {
    final c = context.dy.colors;
    Widget surface(bool hovered) {
      final s = DySurface(
        level: hovered ? DySurfaceLevel.elevated : DySurfaceLevel.surface,
        elevation: variant == DyCardVariant.flat ? (hovered ? DyElevation.low : DyElevation.none) : DyElevation.low,
        radius: _radius,
        padding: _padding,
        child: child,
      );
      if (selected != true) return s;
      return DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(color: c.primary, width: DyBorderWidth.widthStrong),
        ),
        child: s,
      );
    }

    if (onTap == null) return Semantics(container: true, label: semanticLabel, selected: selected, child: surface(false));
    return DyPressable(
      onPressed: onTap,
      state: state,
      lockedReason: lockedReason,
      semanticLabel: semanticLabel,
      selected: selected,
      pressScale: 0.99,
      borderRadius: BorderRadius.circular(_radius),
      builder: (context, s) => surface(s.hovered),
    );
  }
}

/// Kart başlık satırı: başlık, alt başlık ve sağda eylem. Başlık semantik olarak header'dır.
class DyCardHeader extends StatelessWidget {
  const DyCardHeader({super.key, required this.title, this.subtitle, this.action});
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    return Padding(
      padding: const EdgeInsets.only(bottom: DySpacing.md),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: DySpacing.md, children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: DySpacing.xxs, children: [
            Semantics(header: true, child: Text(title, style: dy.text(DyTextStyle.h4))),
            if (subtitle != null) Text(subtitle!, style: dy.text(DyTextStyle.bodySm, tone: DyTextTone.secondary)),
          ]),
        ),
        if (action != null) action!,
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// List / ListItem
// ─────────────────────────────────────────────────────────────────────────────

/// Satır listesi. [dividers] satırlar arasına ince ayraç koyar.
class DyList extends StatelessWidget {
  const DyList({super.key, required this.children, this.dividers = true, this.semanticLabel});
  final List<Widget> children;
  final bool dividers;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.dy.colors;
    return Semantics(
      container: true,
      label: semanticLabel,
      explicitChildNodes: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0 && dividers) Divider(height: DyBorderWidth.widthHairline, thickness: DyBorderWidth.widthHairline, color: c.borderSubtle),
          children[i],
        ],
      ]),
    );
  }
}

/// Liste satırı: öncü (ikon/avatar), başlık + açıklama, sonda değer veya etiket.
/// [onTap] verilirse satırın tamamı buton olur ve sağda yön oku gösterilir.
class DyListItem extends StatelessWidget {
  const DyListItem({super.key, required this.title, this.description, this.meta, this.leading, this.trailing, this.onTap, this.selected = false,
      this.showChevron, this.state = DyComponentState.enabled, this.lockedReason, this.maxDescriptionLines = 2});

  final String title;
  final String? description;

  /// Açıklamanın altında satır içi öğeler (DyStatusTag, DySourceTag). Durum etiketleri [trailing] yerine buraya konur;
  /// dar ekranda başlığı sıkıştırmaz.
  final List<Widget>? meta;
  final Widget? leading;

  /// Kısa değer (kcal, saat).
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;

  /// Varsayılan: [onTap] varsa açık.
  final bool? showChevron;
  final DyComponentState state;
  final String? lockedReason;
  final int maxDescriptionLines;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final chevron = showChevron ?? onTap != null;
    Widget row(DyPressState? s) => Container(
          constraints: const BoxConstraints(minHeight: DySize.targetComfortable),
          padding: const EdgeInsets.symmetric(vertical: DySpacing.md, horizontal: DySpacing.xs),
          decoration: BoxDecoration(
            color: selected ? c.primarySubtle : (s?.hovered ?? false) ? c.surfaceSecondary : null,
            borderRadius: BorderRadius.circular(DyRadius.sm),
          ),
          child: Row(spacing: DySpacing.md, children: [
            if (leading != null) IconTheme.merge(data: IconThemeData(color: c.textSecondary), child: leading!),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, spacing: DySpacing.xxs, children: [
                Text(title, style: dy.text(DyTextStyle.body).copyWith(fontWeight: FontWeight.w700)),
                if (description != null)
                  Text(description!, maxLines: maxDescriptionLines, overflow: TextOverflow.ellipsis, style: dy.text(DyTextStyle.bodySm, tone: DyTextTone.secondary)),
                if (meta != null && meta!.isNotEmpty)
                  Padding(padding: const EdgeInsets.only(top: DySpacing.xxs), child: Wrap(spacing: DySpacing.xs, runSpacing: DySpacing.xs, children: meta!)),
              ]),
            ),
            if (trailing != null)
              DefaultTextStyle.merge(style: dy.text(DyTextStyle.bodySm, tone: DyTextTone.secondary).copyWith(fontFeatures: const [FontFeature.tabularFigures()]), child: trailing!),
            if (chevron) DyIcon(DyIcons.chevronRight, size: DyIconSize.sm, color: c.textMuted),
          ]),
        );

    if (onTap == null) return MergeSemantics(child: Semantics(selected: selected, child: row(null)));
    return DyPressable(
      onPressed: onTap,
      state: state,
      lockedReason: lockedReason,
      selected: selected,
      pressScale: 1,
      borderRadius: BorderRadius.circular(DyRadius.sm),
      builder: (context, s) => row(s),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar
// ─────────────────────────────────────────────────────────────────────────────

enum DyAvatarSize {
  sm(DySize.controlSm, DyTextStyle.caption),
  md(DySize.targetMin, DyTextStyle.label),
  lg(DySize.fab, DyTextStyle.h4),
  xl(DySize.fab * 1.5, DyTextStyle.h3);

  const DyAvatarSize(this.dimension, this.textStyle);
  final double dimension;
  final DyTextStyle textStyle;
}

/// Türkçe kurallarıyla baş harfler: "elif yıldız" → "EY", "ismail ışık" → "İI". React `initials()` ile aynı sonuç.
String dyInitials(String name) {
  String upper(String ch) => switch (ch) { 'i' => 'İ', 'ı' => 'I', _ => ch.toUpperCase() };
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  final first = upper(String.fromCharCode(parts.first.runes.first));
  if (parts.length == 1) return first;
  return first + upper(String.fromCharCode(parts.last.runes.first));
}

/// Kişi avatarı. Fotoğraf yüklenemezse baş harflere düşer. [verified] diyetisyen/klinik doğrulama rozeti.
class DyAvatar extends StatelessWidget {
  const DyAvatar({super.key, required this.name, this.image, this.size = DyAvatarSize.md, this.verified = false, this.decorative = false, this.onSurface});

  final String name;
  final ImageProvider? image;
  final DyAvatarSize size;
  final bool verified;

  /// Yanında ad zaten yazılıysa true: ekran okuyucu adı iki kez okumaz.
  final bool decorative;

  /// Avatarın üstünde durduğu zemin. primarySubtle bir zeminde (ör. seçili satır) baş harf zemini kaybolmasın diye verilir.
  final Color? onSurface;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final bg = onSurface == c.primarySubtle ? c.surface : c.primarySubtle;
    final initials = Center(child: Text(dyInitials(name), maxLines: 1, style: dy.text(size.textStyle).copyWith(color: c.onPrimarySubtle, fontWeight: FontWeight.w700, height: 1)));
    final d = size.dimension;
    Widget body = Container(
      width: d,
      height: d,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: image == null ? initials : Image(image: image!, fit: BoxFit.cover, width: d, height: d, errorBuilder: (context, error, stack) => initials),
    );
    if (verified) {
      final badge = math.max(DyIconSize.sm, d * 0.36);
      body = Stack(clipBehavior: Clip.none, children: [
        body,
        Positioned(
          right: -DySpacing.xxs,
          bottom: -DySpacing.xxs,
          child: Container(
            width: badge,
            height: badge,
            decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle, border: Border.all(color: c.surface, width: DyBorderWidth.widthStrong)),
            child: Center(child: DyIcon(DyIcons.check, size: badge * 0.62, color: c.textOnPrimary)),
          ),
        ),
      ]);
    }
    // Ölçek büyüse de avatar daire kalır; baş harfler FittedBox ile sığar.
    body = MediaQuery.withClampedTextScaling(maxScaleFactor: 1.3, child: body);
    if (decorative) return ExcludeSemantics(child: body);
    return Semantics(image: true, label: verified ? '$name, doğrulanmış' : name, excludeSemantics: true, child: body);
  }
}

@immutable
class DyAvatarPerson {
  const DyAvatarPerson({required this.name, this.image});
  final String name;
  final ImageProvider? image;
}

/// Üst üste binen avatarlar; [max] sonrası "+N" ile özetlenir.
class DyAvatarGroup extends StatelessWidget {
  const DyAvatarGroup({super.key, required this.people, required this.label, this.max = 3, this.size = DyAvatarSize.sm});
  final List<DyAvatarPerson> people;
  final String label;
  final int max;
  final DyAvatarSize size;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final shown = people.take(max).toList();
    final rest = people.length - shown.length;
    final d = size.dimension;
    final overlap = DySpacing.sm;
    Widget ring(Widget child) => Container(
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: c.surface, width: DyBorderWidth.widthStrong)),
          child: child,
        );
    final items = <Widget>[
      for (final p in shown) ring(DyAvatar(name: p.name, image: p.image, size: size)),
      if (rest > 0)
        ring(Semantics(
          label: DyStrings.of(context).t('avatar.more', {'count': rest}),
          excludeSemantics: true,
          child: Container(
            width: d,
            height: d,
            decoration: BoxDecoration(color: c.surfaceSecondary, shape: BoxShape.circle),
            child: Center(child: Text('+$rest', maxLines: 1, style: dy.text(size.textStyle, tone: DyTextTone.secondary).copyWith(fontWeight: FontWeight.w700, height: 1))),
          ),
        )),
    ];
    final step = d + DyBorderWidth.widthStrong * 2 - overlap;
    return Semantics(
      container: true,
      label: label,
      explicitChildNodes: true,
      child: SizedBox(
        width: step * (items.length - 1) + d + DyBorderWidth.widthStrong * 2,
        height: d + DyBorderWidth.widthStrong * 2,
        child: Stack(children: [for (var i = 0; i < items.length; i++) Positioned(left: step * i, top: 0, child: items[i])]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Progress
// ─────────────────────────────────────────────────────────────────────────────

enum DyProgressTone { primary, success, warning, carb, protein, fat }

Color _toneColor(DyColors c, DyProgressTone t) => switch (t) {
      DyProgressTone.primary => c.primary,
      DyProgressTone.success => c.success,
      DyProgressTone.warning => c.warning,
      DyProgressTone.carb => c.macroCarb,
      DyProgressTone.protein => c.macroProtein,
      DyProgressTone.fat => c.macroFat,
    };

/// Doğrusal ilerleme. [value] null ise belirsiz (indeterminate); hareket azaltıldığında sabit durur.
/// Hedef aşımında çubuk dolu kalır; aşım bilgisi [valueText] ile metin olarak verilir (renk tek gösterge değildir).
class DyProgressBar extends StatelessWidget {
  const DyProgressBar({super.key, required this.value, required this.label, this.max = 100, this.valueText, this.tone = DyProgressTone.primary,
      this.showLabel = false, this.compact = false});

  final double? value;
  final double max;
  final String label;
  final String? valueText;
  final DyProgressTone tone;
  final bool showLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final pct = value == null ? null : (value! / max).clamp(0.0, 1.0);
    final text = valueText ?? (pct == null ? null : DyFormat.percent(pct));
    final height = compact ? DySpacing.xs + DySpacing.xxs : DySpacing.sm;
    final track = ClipRRect(
      borderRadius: BorderRadius.circular(DyRadius.full),
      child: SizedBox(
        height: height,
        child: ColoredBox(
          color: c.macroTrack,
          child: pct == null
              ? _Indeterminate(color: _toneColor(c, tone), animate: !dy.reduceMotion)
              : TweenAnimationBuilder<double>(
                  tween: Tween(end: pct),
                  duration: dy.duration(DyDuration.deliberate),
                  curve: DyEasing.emphasized,
                  builder: (context, v, _) => FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: v,
                    child: DecoratedBox(decoration: BoxDecoration(color: _toneColor(c, tone), borderRadius: BorderRadius.circular(DyRadius.full))),
                  ),
                ),
        ),
      ),
    );
    return Semantics(
      label: label,
      value: text,
      excludeSemantics: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, spacing: DySpacing.xs, children: [
        if (showLabel)
          Wrap(alignment: WrapAlignment.spaceBetween, spacing: DySpacing.sm, children: [
            Text(label, style: dy.text(DyTextStyle.caption, tone: DyTextTone.secondary).copyWith(fontWeight: FontWeight.w600)),
            if (text != null) Text(text, style: dy.text(DyTextStyle.caption).copyWith(fontWeight: FontWeight.w700, fontFeatures: const [FontFeature.tabularFigures()])),
          ]),
        track,
      ]),
    );
  }
}

class _Indeterminate extends StatefulWidget {
  const _Indeterminate({required this.color, required this.animate});
  final Color color;
  final bool animate;
  @override
  State<_Indeterminate> createState() => _IndeterminateState();
}

class _IndeterminateState extends State<_Indeterminate> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: DyDuration.deliberate * 2);

  @override
  void initState() {
    super.initState();
    if (widget.animate) _c.repeat();
  }

  @override
  void didUpdateWidget(_Indeterminate old) {
    super.didUpdateWidget(old);
    if (widget.animate && !_c.isAnimating) _c.repeat();
    if (!widget.animate) _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) => FractionallySizedBox(
          widthFactor: 0.4,
          alignment: Alignment(widget.animate ? DyEasing.standard.transform(_c.value) * 2 - 1 : -1, 0),
          child: DecoratedBox(decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(DyRadius.full))),
        ),
      );
}

enum DyProgressRingSize {
  md(DySize.fab * 1.3),
  lg(DySize.fab * 2);

  const DyProgressRingSize(this.dimension);
  final double dimension;
}

/// Halka gösterge (kalori halkası tabanı). Ortadaki içerik görseldir; değer [valueText] ile okunur.
class DyProgressRing extends StatelessWidget {
  const DyProgressRing({super.key, required this.value, required this.label, this.max = 100, this.valueText, this.size = DyProgressRingSize.lg,
      this.tone = DyProgressTone.primary, this.child});

  final double value;
  final double max;
  final String label;
  final String? valueText;
  final DyProgressRingSize size;
  final DyProgressTone tone;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final pct = (value / max).clamp(0.0, 1.0);
    final d = size.dimension;
    return Semantics(
      label: label,
      value: valueText ?? DyFormat.percent(pct),
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: d,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: pct),
          duration: dy.duration(DyDuration.deliberate),
          curve: DyEasing.emphasized,
          builder: (context, v, inner) => CustomPaint(
            painter: _RingPainter(progress: v, track: c.macroTrack, fill: _toneColor(c, tone)),
            child: inner,
          ),
          child: child == null ? null : Center(child: Padding(padding: EdgeInsets.all(d * 0.14), child: FittedBox(fit: BoxFit.scaleDown, child: child))),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.track, required this.fill});
  final double progress;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    // React ile aynı oran: viewBox 100, r=44, stroke 9.
    final stroke = size.shortestSide * 0.09;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.shortestSide * 0.44);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawArc(rect, 0, math.pi * 2, false, p..color = track);
    if (progress > 0) canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * progress, false, p..color = fill..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress || old.track != track || old.fill != fill;
}

// ─────────────────────────────────────────────────────────────────────────────
// StatCard
// ─────────────────────────────────────────────────────────────────────────────

enum DyDeltaIntent { increaseIsGood, decreaseIsGood, neutral }

/// Tek metrik kartı. Değişim yönü ikon + metinle verilir; renk tek gösterge değildir.
/// Gizli metrikte ([DyVisibility.hidden]) değişim de gösterilmez (React StatCard ile aynı kural).
class DyStatCard extends StatelessWidget {
  const DyStatCard({super.key, required this.label, required this.value, this.unit, this.fractionDigits = 1, this.delta, this.deltaUnit,
      this.deltaIntent = DyDeltaIntent.neutral, this.deltaContext, this.icon, this.footer, this.visibility = DyVisibility.visible});

  final String label;
  final num? value;
  final String? unit;
  final int fractionDigits;
  final num? delta;
  final String? deltaUnit;
  final DyDeltaIntent deltaIntent;
  final String? deltaContext;
  final DyIconData? icon;
  final Widget? footer;
  final DyVisibility visibility;

  /// "+4 puan", "−3" (U+2212), "0".
  static String formatDelta(num delta, {int fractionDigits = 1, String? unit}) {
    final sign = delta > 0 ? '+' : delta < 0 ? '−' : '';
    final n = DyFormat.number(delta.abs(), maxFractionDigits: fractionDigits);
    return '$sign$n${unit == null ? '' : '${DyFormat.nbsp}$unit'}';
  }

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final d = delta;
    final dir = d == null || d == 0 ? 0 : d.sign.toInt();
    final good = deltaIntent == DyDeltaIntent.neutral || dir == 0 ? null : (dir > 0) == (deltaIntent == DyDeltaIntent.increaseIsGood);
    final deltaColor = good == null ? c.textSecondary : good ? c.successStrong : c.errorStrong;
    return DyCard(
      child: Semantics(
        container: true,
        label: label,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: DySpacing.xs, children: [
          Row(spacing: DySpacing.xs, children: [
            if (icon != null) DyIcon(icon!, size: DyIconSize.sm, color: c.textSecondary),
            Flexible(child: ExcludeSemantics(child: Text(label, style: dy.text(DyTextStyle.label, tone: DyTextTone.secondary)))),
          ]),
          DyNumber(value, unit: unit, style: DyTextStyle.numericLg, fractionDigits: fractionDigits, visibility: visibility),
          if (d != null && visibility != DyVisibility.hidden)
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: DySpacing.xs, children: [
              DyIcon(dir > 0 ? DyIcons.arrowUp : dir < 0 ? DyIcons.arrowDown : DyIcons.minus, size: DyIconSize.sm, color: deltaColor),
              Text(formatDelta(d, fractionDigits: fractionDigits, unit: deltaUnit),
                  style: dy.text(DyTextStyle.caption).copyWith(color: deltaColor, fontWeight: FontWeight.w700, fontFeatures: const [FontFeature.tabularFigures()])),
              if (deltaContext != null) Text(deltaContext!, style: dy.text(DyTextStyle.caption, tone: DyTextTone.muted)),
            ]),
          if (footer != null) footer!,
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip / FilterChips
// ─────────────────────────────────────────────────────────────────────────────

/// Seçilebilir çip (filtre, besin grubu). Seçili/seçili değil durumu toggled semantiğiyle okunur.
class DyChip extends StatelessWidget {
  const DyChip({super.key, required this.label, this.selected = false, this.onSelected, this.icon, this.count, this.onRemove,
      this.state = DyComponentState.enabled, this.lockedReason});

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final DyIconData? icon;
  final int? count;

  /// Verilirse sonda kaldırma ikonu gösterilir (seçili filtreyi kaldır). Tüm çip tıklanabilir alandır.
  final VoidCallback? onRemove;
  final DyComponentState state;
  final String? lockedReason;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final fg = selected ? c.textOnInverse : c.textSecondary;
    final style = dy.text(DyTextStyle.label).copyWith(color: fg);
    return DyPressable(
      onPressed: onRemove ?? (onSelected == null ? null : () => onSelected!(!selected)),
      state: state,
      lockedReason: lockedReason,
      toggled: onRemove == null ? selected : null,
      semanticLabel: [label, if (count != null) '$count', if (onRemove != null) 'kaldır'].join(', '),
      borderRadius: BorderRadius.circular(DyRadius.full),
      minSize: const Size(DySize.targetMin, DySize.targetMin),
      builder: (context, s) => Center(
        widthFactor: 1,
        child: AnimatedContainer(
          duration: dy.duration(DyDuration.fast),
          constraints: const BoxConstraints(minHeight: DySize.controlSm),
          padding: const EdgeInsets.symmetric(horizontal: DySpacing.md, vertical: DySpacing.xs),
          decoration: BoxDecoration(
            color: selected ? c.surfaceInverse : s.hovered ? c.surfaceSunken : c.surfaceSecondary,
            borderRadius: BorderRadius.circular(DyRadius.full),
          ),
          child: Opacity(
            opacity: state == DyComponentState.disabled ? DyOpacity.disabled : 1,
            child: Row(mainAxisSize: MainAxisSize.min, spacing: DySpacing.xs, children: [
              if (icon != null) DyIcon(icon!, size: DyIconSize.sm, color: fg),
              Flexible(child: Text(label, style: style, maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (count != null) Text(DyFormat.number(count!), style: style.copyWith(fontWeight: FontWeight.w800, fontFeatures: const [FontFeature.tabularFigures()])),
              if (onRemove != null) DyIcon(DyIcons.x, size: DyIconSize.sm, color: fg),
            ]),
          ),
        ),
      ),
    );
  }
}

@immutable
class DyFilterOption {
  const DyFilterOption({required this.value, required this.label, this.count});
  final String value;
  final String label;
  final int? count;
}

/// Mobil filtre çipleri: yatay kaydırılan çoklu seçim + "Temizle". React `FilterBar` filtre grubunun mobil karşılığı.
class DyFilterChips extends StatelessWidget {
  const DyFilterChips({super.key, required this.label, required this.options, required this.values, required this.onChanged, this.showClear = true});
  final String label;
  final List<DyFilterOption> options;
  final Set<String> values;
  final ValueChanged<Set<String>> onChanged;
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    final t = DyStrings.of(context);
    final c = context.dy.colors;
    return Semantics(
      container: true,
      label: label,
      explicitChildNodes: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(spacing: DySpacing.sm, children: [
          for (final o in options)
            DyChip(
              label: o.label,
              count: o.count,
              selected: values.contains(o.value),
              onSelected: (on) => onChanged(on ? {...values, o.value} : ({...values}..remove(o.value))),
            ),
          if (showClear && values.isNotEmpty)
            DyPressable(
              onPressed: () => onChanged(<String>{}),
              semanticLabel: t.t('filter.clearAll'),
              borderRadius: BorderRadius.circular(DyRadius.full),
              minSize: const Size(DySize.targetMin, DySize.targetMin),
              builder: (context, s) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: DySpacing.sm),
                child: Center(widthFactor: 1, child: Text(t.t('filter.clearAll'), style: context.dy.text(DyTextStyle.label).copyWith(color: c.textLink))),
              ),
            ),
        ]),
      ),
    );
  }
}
