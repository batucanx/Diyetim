/// HTTP soyutlaması. Hiçbir paket içe aktarmaz; hatalar [ApiException] olarak atılır.
abstract class HttpHelper {
  /// JSON nesnesi döndüren GET.
  Future<Map<String, Object?>> getJson(String path, {Map<String, Object?> query = const {}});
}
