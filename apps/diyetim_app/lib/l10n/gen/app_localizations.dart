import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('tr')];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Diyetim'**
  String get appTitle;

  /// No description provided for @todayTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get todayTitle;

  /// No description provided for @todayLoadingLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün planı'**
  String get todayLoadingLabel;

  /// No description provided for @todaySearchFoods.
  ///
  /// In tr, this message translates to:
  /// **'Besin ara'**
  String get todaySearchFoods;

  /// Bugün ekranındaki ilk bölüm (karar 0002)
  ///
  /// In tr, this message translates to:
  /// **'Diyetisyeninden not'**
  String get dietitianNoteTitle;

  /// No description provided for @noteReadMore.
  ///
  /// In tr, this message translates to:
  /// **'Devamını oku'**
  String get noteReadMore;

  /// No description provided for @noteReadLess.
  ///
  /// In tr, this message translates to:
  /// **'Daha az göster'**
  String get noteReadLess;

  /// No description provided for @timeJustNow.
  ///
  /// In tr, this message translates to:
  /// **'az önce'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk önce'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In tr, this message translates to:
  /// **'{hours} saat önce'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeYesterday.
  ///
  /// In tr, this message translates to:
  /// **'dün'**
  String get timeYesterday;

  /// No description provided for @timeDaysAgo.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün önce'**
  String timeDaysAgo(int days);

  /// No description provided for @mealsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğünler'**
  String get mealsTitle;

  /// No description provided for @mealsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bugün için öğün yok'**
  String get mealsEmptyTitle;

  /// No description provided for @mealsEmptyDescription.
  ///
  /// In tr, this message translates to:
  /// **'Diyetisyenin henüz bugünün planını yayınlamadı.'**
  String get mealsEmptyDescription;

  /// No description provided for @mealCaloriesLabel.
  ///
  /// In tr, this message translates to:
  /// **'{meal} kalorisi'**
  String mealCaloriesLabel(String meal);

  /// No description provided for @unitKcal.
  ///
  /// In tr, this message translates to:
  /// **'kcal'**
  String get unitKcal;

  /// No description provided for @unitGram.
  ///
  /// In tr, this message translates to:
  /// **'g'**
  String get unitGram;

  /// No description provided for @foodSearchTitle.
  ///
  /// In tr, this message translates to:
  /// **'Besin ara'**
  String get foodSearchTitle;

  /// No description provided for @foodSearchFieldLabel.
  ///
  /// In tr, this message translates to:
  /// **'Besin ara'**
  String get foodSearchFieldLabel;

  /// No description provided for @foodSearchPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Mercimek, yulaf, tavuk…'**
  String get foodSearchPlaceholder;

  /// No description provided for @foodSearchHint.
  ///
  /// In tr, this message translates to:
  /// **'Aramak için en az 2 harf yaz.'**
  String get foodSearchHint;

  /// No description provided for @foodSearchHintTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ne yedin?'**
  String get foodSearchHintTitle;

  /// No description provided for @foodSearchResultsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Arama sonuçları'**
  String get foodSearchResultsLabel;

  /// No description provided for @foodSearchResultCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} sonuç'**
  String foodSearchResultCount(int count);

  /// No description provided for @foodSearchNoResultsTitle.
  ///
  /// In tr, this message translates to:
  /// **'“{query}” için sonuç yok'**
  String foodSearchNoResultsTitle(String query);

  /// No description provided for @foodSearchNoResultsDescription.
  ///
  /// In tr, this message translates to:
  /// **'Farklı bir yazım dene ya da daha genel bir kelimeyle ara.'**
  String get foodSearchNoResultsDescription;

  /// No description provided for @foodSearchQuotaTitle.
  ///
  /// In tr, this message translates to:
  /// **'Besin arama şu an yoğun'**
  String get foodSearchQuotaTitle;

  /// No description provided for @foodSearchQuotaDescription.
  ///
  /// In tr, this message translates to:
  /// **'Çok kişi aynı anda arıyor. Biraz sonra tekrar dene.'**
  String get foodSearchQuotaDescription;

  /// No description provided for @foodServingPer.
  ///
  /// In tr, this message translates to:
  /// **'{serving} başına'**
  String foodServingPer(String serving);

  /// Karbonhidrat, protein, yağ kısaltmaları
  ///
  /// In tr, this message translates to:
  /// **'K {carb} g · P {protein} g · Y {fat} g'**
  String foodMacros(String carb, String protein, String fat);

  /// No description provided for @foodMacrosSemantic.
  ///
  /// In tr, this message translates to:
  /// **'Karbonhidrat {carb} gram, protein {protein} gram, yağ {fat} gram'**
  String foodMacrosSemantic(String carb, String protein, String fat);

  /// No description provided for @foodLoadMore.
  ///
  /// In tr, this message translates to:
  /// **'Daha fazla göster'**
  String get foodLoadMore;

  /// No description provided for @attributionOpen.
  ///
  /// In tr, this message translates to:
  /// **'{text} (bağlantı)'**
  String attributionOpen(String text);

  /// No description provided for @retry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
