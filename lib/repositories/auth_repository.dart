import '../models/user_model.dart';
import '../services/api_client.dart';
import '../utils/constants.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiClient.post(AppConstants.loginEndpoint, data: {
        'username': email,
        'password': password,
      });

      if (response.statusCode == 200 && response.data.containsKey('data')) {
        final data = response.data['data'];
        await apiClient.authService.saveAccessToken(data['access_token']);
        await apiClient.authService.saveRefreshToken(data['refresh_token']);
        return UserModel.fromJson(data['client']);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to login');
    }
  }

  Future<bool?> signUp(
      String email, String password, String firstName, String lastName) async {
    final response = await apiClient.post(AppConstants.signUpEndpoint, data: {
      'email': email,
      'password': password,
      'username': email,
      'firstname': firstName,
      'lastname': lastName,
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<UserModel?> me() async {
    try {
      final response = await apiClient.post(AppConstants.meEndpoint);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to login with token');
    }
  }
}
