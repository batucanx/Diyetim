import 'package:dy_health/dy_health.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('her durum değerinin stili var ve ikonu sette', () {
    final styles = [
      for (final v in DyMealStatus.values) v.style,
      for (final v in DyAppointmentStatus.values) v.style,
      for (final v in DyLabValueStatus.values) v.style,
      for (final v in DyDataSource.values) v.style,
    ];
    for (final s in styles) {
      expect(DyIcons.all.map((i) => i.name), contains(s.icon), reason: s.i18nKey);
    }
  });
  test('çeviri anahtarları ortak adları kullanır', () {
    expect(DyMealStatus.pendingReview.style.i18nKey, 'mealStatus.pending-review');
    expect(DyAppointmentStatus.noShow.style.i18nKey, 'appointmentStatus.no-show');
  });
  test('tonlar her iki temada çözülür', () {
    for (final c in [DyColors.light, DyColors.dark]) {
      for (final t in DyStatusTone.values) {
        expect(DyToneColors.of(c, t).foreground, isNotNull);
      }
    }
  });
}
