import '../helpers/http/exceptions/api_exception.dart';

/// Riverpod 3 varsayılanı hatalı sağlayıcıyı 10 kez sessizce yeniden dener: kullanıcı hatayı saniyelerce görmez
/// ve besin aramasında sağlayıcı kotası harcanır. Kural: yalnız geçici ağ hataları, bir kez, 1 sn sonra.
/// Kota, yetki ve sunucu hataları yeniden denenmez; kullanıcı "Tekrar dene" ile karar verir.
Duration? providerRetry(int retryCount, Object error) {
  if (retryCount >= 1) return null;
  return switch (error) {
    ApiException(code: ApiErrorCode.network || ApiErrorCode.timeout) => const Duration(seconds: 1),
    _ => null,
  };
}
