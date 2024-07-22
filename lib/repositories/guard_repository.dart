import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../services/api_client.dart';

class GuardRepository {
  final ApiClient apiClient;

  GuardRepository({required this.apiClient});

  Future<List<UserModel>> fetchGuards() async {
    try {
      final response = await apiClient.get('/users/?chat=true');

      List<UserModel> Guards = (response.data['data'] as List)
          .map((Guard) => UserModel.fromJson(Guard))
          .toList();
      return Guards;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch Guard list');
    }
  }
}
