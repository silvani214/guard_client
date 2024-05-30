class AppConstants {
  // API Endpoints
  // static const String baseUrl = 'http://192.168.10.121:8080/api';
  static const String baseUrl = 'http://35.183.88.228:8080/api';
  static const String meEndpoint = '/auth/client/me';
  static const String loginEndpoint = '/auth/client/signin';
  static const String signUpEndpoint = '/auth/client/signup';
  static const String refreshTokenEndpoint = '/auth/client/refresh-token';

  // Shared Preferences Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDetailKey = 'user_detail';
}
