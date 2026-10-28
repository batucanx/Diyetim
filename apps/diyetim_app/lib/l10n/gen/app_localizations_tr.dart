// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Diyetim';

  @override
  String get todayTitle => 'Bugün';

  @override
  String get todayLoadingLabel => 'Bugünün planı';

  @override
  String get todaySearchFoods => 'Besin ara';

  @override
  String get dietitianNoteTitle => 'Diyetisyeninden not';

  @override
  String get noteReadMore => 'Devamını oku';

  @override
  String get noteReadLess => 'Daha az göster';

  @override
  String get timeJustNow => 'az önce';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes dk önce';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours saat önce';
  }

  @override
  String get timeYesterday => 'dün';

  @override
  String timeDaysAgo(int days) {
    return '$days gün önce';
  }

  @override
  String get mealsTitle => 'Öğünler';

  @override
  String get mealsEmptyTitle => 'Bugün için öğün yok';

  @override
  String get mealsEmptyDescription =>
      'Diyetisyenin henüz bugünün planını yayınlamadı.';

  @override
  String mealCaloriesLabel(String meal) {
    return '$meal kalorisi';
  }

  @override
  String get unitKcal => 'kcal';

  @override
  String get unitGram => 'g';

  @override
  String get foodSearchTitle => 'Besin ara';

  @override
  String get foodSearchFieldLabel => 'Besin ara';

  @override
  String get foodSearchPlaceholder => 'Mercimek, yulaf, tavuk…';

  @override
  String get foodSearchHint => 'Aramak için en az 2 harf yaz.';

  @override
  String get foodSearchHintTitle => 'Ne yedin?';

  @override
  String get foodSearchResultsLabel => 'Arama sonuçları';

  @override
  String foodSearchResultCount(int count) {
    return '$count sonuç';
  }

  @override
  String foodSearchNoResultsTitle(String query) {
    return '“$query” için sonuç yok';
  }

  @override
  String get foodSearchNoResultsDescription =>
      'Farklı bir yazım dene ya da daha genel bir kelimeyle ara.';

  @override
  String get foodSearchQuotaTitle => 'Besin arama şu an yoğun';

  @override
  String get foodSearchQuotaDescription =>
      'Çok kişi aynı anda arıyor. Biraz sonra tekrar dene.';

  @override
  String foodServingPer(String serving) {
    return '$serving başına';
  }

  @override
  String foodMacros(String carb, String protein, String fat) {
    return 'K $carb g · P $protein g · Y $fat g';
  }

  @override
  String foodMacrosSemantic(String carb, String protein, String fat) {
    return 'Karbonhidrat $carb gram, protein $protein gram, yağ $fat gram';
  }

  @override
  String get foodLoadMore => 'Daha fazla göster';

  @override
  String attributionOpen(String text) {
    return '$text (bağlantı)';
  }

  @override
  String get retry => 'Tekrar dene';
}
