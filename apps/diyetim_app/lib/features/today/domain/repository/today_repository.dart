import '../usecases/get_today.dart';

abstract class TodayRepository {
  /// Girdi: tarih (varsayılan bugün) · Çıktı: diyetisyen notu ve öğünler.
  Future<GetTodayUsecaseOutput> getToday(GetTodayUsecaseInput input);
}
