/// Harici bağlantı açma soyutlaması (tarayıcı/uygulama). Paket içe aktarmaz.
abstract class UrlHelper {
  /// Bağlantıyı sistem tarayıcısında açar; açılamazsa false.
  Future<bool> openExternal(Uri url);
}
