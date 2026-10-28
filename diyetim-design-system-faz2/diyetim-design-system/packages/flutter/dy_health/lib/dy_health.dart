/// Diyetim sağlık ve beslenme component'leri.
///
/// Faz 2 durumu: yalnızca temel. Durum enum'ları ve görsel eşlemeleri (ton, ikon, çeviri anahtarı)
/// `spec/contracts.json` kaynağından dy_tokens içinde üretilir (`DyMealStatus.pendingReview.style`);
/// durumu gösteren `DyStatusTag` dy_ui içindedir. Kalori, makro, öğün, besin, plan, randevu, tahlil,
/// ilaç ve AI component'leri Faz 3'te bu pakete eklenir.
library;

export 'package:dy_ui/dy_ui.dart';
