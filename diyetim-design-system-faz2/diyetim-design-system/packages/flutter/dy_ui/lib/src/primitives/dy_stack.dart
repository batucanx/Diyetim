import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/widgets.dart';

/// Spacing token'larıyla dikey veya yatay yerleşim. [wrap] true ise yatay öğeler satır kaydırır
/// (büyük metin ölçeğinde taşmayı önler).
class DyStack extends StatelessWidget {
  const DyStack({super.key, this.direction = Axis.vertical, this.gap = DySpacing.lg, this.crossAxisAlignment = CrossAxisAlignment.stretch,
      this.mainAxisAlignment = MainAxisAlignment.start, this.wrap = false, required this.children});

  final Axis direction;

  /// [DySpacing] değerlerinden biri.
  final double gap;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool wrap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (wrap && direction == Axis.horizontal) {
      return Wrap(spacing: gap, runSpacing: gap, crossAxisAlignment: WrapCrossAlignment.center, children: children);
    }
    return Flex(
      direction: direction,
      spacing: gap,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: direction == Axis.horizontal && crossAxisAlignment == CrossAxisAlignment.stretch ? CrossAxisAlignment.center : crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: children,
    );
  }
}

/// Tek seferlik boşluk. Mümkünse [DyStack.gap] tercih edilir.
class DyGap extends StatelessWidget {
  const DyGap(this.size, {super.key});

  /// [DySpacing] değerlerinden biri.
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size);
}
