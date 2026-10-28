import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import 'url_helper.dart';

@LazySingleton(as: UrlHelper)
class UrlHelperImpl implements UrlHelper {
  const UrlHelperImpl();

  @override
  Future<bool> openExternal(Uri url) async {
    if (!url.isScheme('https')) return false;
    try {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } on Object {
      return false;
    }
  }
}
