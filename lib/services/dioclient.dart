import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final Dio dio = Dio();

  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static void initialize({required void Function() onTokenExpired}) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
              final token = await storage.read(key: 'AccessToken');

              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }

              handler.next(options);
            },

        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            await storage.delete(key: 'AccessToken');

            onTokenExpired();
          }

          handler.next(error);
        },
      ),
    );
  }
}
