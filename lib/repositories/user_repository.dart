import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class UserRepository {
  final String baseUrl;

  UserRepository({required this.baseUrl});

  Future<UserModel> fetchUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/clients/$userId'));
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<bool> updateUser(UserModel user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clients/${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );
    return response.statusCode == 200;
  }
}
