import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/widgets.dart';

import '../generated/dy_icons.g.dart';

export '../generated/dy_icons.g.dart';

/// Tek çizgi kalınlığında ikon (spec/icons.json). Rengi verilmezse çevredeki metin renginden alır.
/// [semanticLabel] verilirse anlam taşır; verilmezse dekoratiftir.
class DyIcon extends StatelessWidget {
  const DyIcon(this.icon, {super.key, this.size = DyIconSize.md, this.color, this.semanticLabel});

  final DyIconData icon;

  /// [DyIconSize.sm] 16 · md 20 · lg 24 · xl 32.
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = color ?? DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000);
    final paint = SizedBox.square(dimension: size, child: CustomPaint(painter: _IconPainter(icon, c)));
    return semanticLabel == null ? ExcludeSemantics(child: paint) : Semantics(label: semanticLabel, image: true, child: paint);
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.icon, this.color);
  final DyIconData icon;
  final Color color;

  static final _cache = <String, Path>{};

  static Path _path(DyIconData icon) => _cache.putIfAbsent(icon.name, () {
        final p = Path();
        final o = icon.ops;
        var i = 0;
        while (i < o.length) {
          switch (o[i].toInt()) {
            case 0:
              p.moveTo(o[i + 1], o[i + 2]);
              i += 3;
            case 1:
              p.lineTo(o[i + 1], o[i + 2]);
              i += 3;
            case 2:
              p.cubicTo(o[i + 1], o[i + 2], o[i + 3], o[i + 4], o[i + 5], o[i + 6]);
              i += 7;
            case 3:
              p.quadraticBezierTo(o[i + 1], o[i + 2], o[i + 3], o[i + 4]);
              i += 5;
            default:
              p.close();
              i += 1;
          }
        }
        return p;
      });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.scale(scale);
    canvas.drawPath(
      _path(icon),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = DyIcons.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(_IconPainter old) => old.icon != icon || old.color != color;
}
