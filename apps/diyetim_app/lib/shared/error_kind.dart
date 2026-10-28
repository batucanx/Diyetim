import 'package:dy_ui/dy_ui.dart' show DyErrorKind;

import '../helpers/http/exceptions/api_exception.dart';

/// Uygulama hatasını tasarım sisteminin hata durumuna çevirir (metinler DyErrorState'te).
DyErrorKind errorKindOf(Object error) => switch (error) {
      ApiException(code: ApiErrorCode.network) => DyErrorKind.network,
      ApiException(code: ApiErrorCode.timeout) => DyErrorKind.timeout,
      ApiException(code: ApiErrorCode.unauthorized) => DyErrorKind.permission,
      ApiException(code: ApiErrorCode.notFound) => DyErrorKind.notFound,
      _ => DyErrorKind.server,
    };
