import 'package:dio/dio.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class ApiClient {
  final _dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    sendTimeout: Duration(seconds: 10),
  ));
  final AuthService authService;

  ApiClient({required this.authService}) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await authService.getAccessToken();
        print(accessToken);
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        handler.next(options);
      },
      onError: (DioError e, handler) async {
        // if (e.response?.statusCode == 401) {
        //   final refreshToken = await authService.getRefreshToken();
        //   if (refreshToken != null) {
        //     try {
        //       final response = await _dio.post(
        //         '${AppConstants.baseUrl}${AppConstants.refreshTokenEndpoint}',
        //         data: {'refresh_token': refreshToken},
        //       );
        //       final newAccessToken = response.data['access_token'];
        //       await authService.saveAccessToken(newAccessToken);

        //       e.requestOptions.headers['Authorization'] =
        //           'Bearer $newAccessToken';
        //       final cloneRequest = await _dio.request(
        //         e.requestOptions.path,
        //         options: Options(
        //           method: e.requestOptions.method,
        //           headers: e.requestOptions.headers,
        //         ),
        //         data: e.requestOptions.data,
        //         queryParameters: e.requestOptions.queryParameters,
        //       );
        //       return handler.resolve(cloneRequest);
        //     } catch (e) {
        //       authService.logout();
        //     }
        //   }
        // }
        return handler.next(e);
      },
    ));
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post('${AppConstants.baseUrl}$path', data: data);
  }

  Future<Response> get(String path) async {
    return _dio.get('${AppConstants.baseUrl}$path');
  }
}
