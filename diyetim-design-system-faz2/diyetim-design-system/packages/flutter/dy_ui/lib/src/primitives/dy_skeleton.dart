import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/widgets.dart';

import '../theme/dy_context.dart';

enum DySkeletonShape { text, rect, circle }

/// Yüklenen içeriğin yerini birebir ölçüyle tutar (layout kaymaz). Ekran okuyucudan gizlidir;
/// yükleme durumunu kapsayıcı bildirir. Hareketi azalt açıkken shimmer çalışmaz.
class DySkeleton extends StatefulWidget {
  const DySkeleton({super.key, this.shape = DySkeletonShape.rect, this.width, this.height, this.lines = 1, this.radius});

  final DySkeletonShape shape;
  final double? width;
  final double? height;

  /// shape=text iken satır sayısı; son satır kısa çizilir.
  final int lines;
  final double? radius;

  @override
  State<DySkeleton> createState() => _DySkeletonState();
}

class _DySkeletonState extends State<DySkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: DyDuration.deliberate * 2.4);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.dy.reduceMotion) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _bar(double? w, double h, double r) {
    final c = context.dy.colors;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r),
          gradient: LinearGradient(
            colors: [c.surfaceSecondary, c.surface, c.surfaceSecondary],
            stops: const [0.0, 0.5, 1.0],
            begin: Alignment(-3 + _c.value * 4, 0),
            end: Alignment(-1 + _c.value * 4, 0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lineH = (DyTypeScale.compact(DyTextStyle.body).fontSize ?? 16) * 0.75 * MediaQuery.textScalerOf(context).scale(1);
    final child = switch (widget.shape) {
      DySkeletonShape.text => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: DySpacing.sm,
          children: [
            for (var i = 0; i < widget.lines; i++)
              FractionallySizedBox(widthFactor: widget.lines > 1 && i == widget.lines - 1 ? 0.6 : 1, child: _bar(null, lineH, DyRadius.xs)),
          ],
        ),
      DySkeletonShape.circle => _bar(widget.width, widget.height ?? widget.width ?? DySize.controlLg, DyRadius.full),
      DySkeletonShape.rect => _bar(widget.width, widget.height ?? DySize.controlLg, widget.radius ?? DyRadius.sm),
    };
    return ExcludeSemantics(child: SizedBox(width: widget.shape == DySkeletonShape.text ? widget.width : null, child: child));
  }
}
