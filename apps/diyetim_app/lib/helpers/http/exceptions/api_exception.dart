/// Backend hata sözleşmesi (docs/api/openapi.yaml → Error.code).
enum ApiErrorCode { invalidQuery, notFound, unauthorized, quotaExceeded, providerUnavailable, internal, network, timeout }

/// Ağ ve backend hataları tek tipe çevrilir; üst katmanlar paket (dio) istisnası görmez.
class ApiException implements Exception {
  const ApiException(this.code, [this.message]);
  final ApiErrorCode code;

  /// Geliştirici içindir; kullanıcıya gösterilmez.
  final String? message;

  static ApiErrorCode codeFromWire(String? wire) => switch (wire) {
        'INVALID_QUERY' => ApiErrorCode.invalidQuery,
        'NOT_FOUND' => ApiErrorCode.notFound,
        'UNAUTHORIZED' => ApiErrorCode.unauthorized,
        'QUOTA_EXCEEDED' => ApiErrorCode.quotaExceeded,
        'PROVIDER_UNAVAILABLE' => ApiErrorCode.providerUnavailable,
        _ => ApiErrorCode.internal,
      };

  @override
  String toString() => 'ApiException(${code.name}${message == null ? '' : ': $message'})';
}
