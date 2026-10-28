/// Türkçe sayı biçimi (intl paketine bağımlı değildir): 1.842 · 6,3 · %48.
/// Değer ile birim arasında yalnızca U+00A0 kullanılır (Nunito U+202F içermez).
abstract final class DyFormat {
  static const nbsp = ' ';

  static String number(num value, {int maxFractionDigits = 1, int minFractionDigits = 0}) {
    final negative = value < 0;
    final fixed = value.abs().toStringAsFixed(maxFractionDigits);
    final parts = fixed.split('.');
    var frac = parts.length > 1 ? parts[1] : '';
    while (frac.length > minFractionDigits && frac.endsWith('0')) {
      frac = frac.substring(0, frac.length - 1);
    }
    final intPart = parts[0];
    final buf = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buf.write('.');
      buf.write(intPart[i]);
    }
    final out = frac.isEmpty ? buf.toString() : '$buf,$frac';
    return negative && out != '0' ? '-$out' : out;
  }

  static String percent(num ratio) => '%${number(ratio * 100, maxFractionDigits: 0)}';

  /// "6,5" · "1.842,5" · "6.5" → sayı; geçersizse null.
  static double? parse(String input) {
    final s = input.trim().replaceAll(RegExp(r'[\s ]'), '');
    if (s.isEmpty || s == '-' || s == ',') return null;
    String norm;
    if (s.contains(',')) {
      norm = s.replaceAll('.', '').replaceFirst(',', '.');
    } else if (RegExp(r'^-?\d{1,3}(\.\d{3})+$').hasMatch(s)) {
      norm = s.replaceAll('.', '');
    } else {
      norm = s;
    }
    if (!RegExp(r'^-?\d*\.?\d+$').hasMatch(norm)) return null;
    return double.tryParse(norm);
  }

  /// Türkçe büyük/küçük harf eşlemesiyle küçük harfe çevirme (İ→i, I→ı).
  static String lowerTr(String s) => s.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();
}
