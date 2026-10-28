/// Derleme anı yapılandırması: `--dart-define=DIYETIM_API_BASE_URL=https://…`.
/// Adres verilmezse uygulama sözleşmeye (docs/api/openapi.yaml) uyan sahte veriyle çalışır.
abstract final class AppConfig {
  static const apiBaseUrl = String.fromEnvironment('DIYETIM_API_BASE_URL');
  static bool get useFakeData => apiBaseUrl.isEmpty;
}
