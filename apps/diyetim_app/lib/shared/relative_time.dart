import '../l10n/gen/app_localizations.dart';

/// "az önce" · "12 dk önce" · "3 saat önce" · "dün" · "4 gün önce".
String relativeTime(AppLocalizations l10n, DateTime then, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final diff = n.difference(then.toLocal());
  if (diff.inMinutes < 1) return l10n.timeJustNow;
  if (diff.inHours < 1) return l10n.timeMinutesAgo(diff.inMinutes);
  final today = DateTime(n.year, n.month, n.day);
  final day = DateTime(then.toLocal().year, then.toLocal().month, then.toLocal().day);
  final days = today.difference(day).inDays;
  if (days == 0) return l10n.timeHoursAgo(diff.inHours);
  if (days == 1) return l10n.timeYesterday;
  return l10n.timeDaysAgo(days);
}
