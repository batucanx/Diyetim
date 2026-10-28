/// Tasarım sistemi enum'larını `wire` adıyla eşler (spec/contracts.json). Bilinmeyen değer null döner.
T? byWire<T>(List<T> values, String? wire, String Function(T) wireOf) {
  if (wire == null) return null;
  for (final v in values) {
    if (wireOf(v) == wire) return v;
  }
  return null;
}
