import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../infrastructure/app_config.dart';
import '../../infrastructure/di/injection.dart';
import 'exceptions/api_exception.dart';
import 'http_helper.dart';

@LazySingleton(as: HttpHelper, env: [Env.remote])
class HttpHelperImpl implements HttpHelper {
  HttpHelperImpl() : _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl, connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 15)));

  final Dio _dio;

  @override
  Future<Map<String, Object?>> getJson(String path, {Map<String, Object?> query = const {}}) async {
    try {
      final res = await _dio.get<Map<String, Object?>>(path, queryParameters: query);
      return res.data ?? const {};
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  ApiException _map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout || DioExceptionType.receiveTimeout || DioExceptionType.sendTimeout:
        return const ApiException(ApiErrorCode.timeout);
      case DioExceptionType.connectionError:
        return ApiException(ApiErrorCode.network, e.message);
      default:
        final body = e.response?.data;
        final wire = body is Map ? body['code'] as String? : null;
        if (wire == null && e.response?.statusCode == 401) return const ApiException(ApiErrorCode.unauthorized);
        return ApiException(ApiException.codeFromWire(wire), body is Map ? body['message'] as String? : e.message);
    }
  }
}
