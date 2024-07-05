import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/visitor_model.dart';
import '../services/api_client.dart';

class VisitorRepository {
  final ApiClient apiClient;
  VisitorRepository({required this.apiClient});

  Future<List<VisitorModel>> fetchVisitors(int siteId) async {
    final response = await apiClient.get('/sites/visitors/$siteId');
    if (response.statusCode == 200) {
      List<VisitorModel> result = response.data
          .map<VisitorModel>((json) => VisitorModel.fromJson(json))
          .toList();
      return result;
    } else {
      throw Exception('Failed to load visitors');
    }
  }
}
