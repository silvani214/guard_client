import 'dart:convert';
import '../models/report_model.dart';
import '../services/api_client.dart';

class ReportRepository {
  final ApiClient apiClient;
  ReportRepository({required this.apiClient});

  Future<List<ReportModel>> fetchReports(int siteId) async {
    print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    print(siteId);
    final response =
        await apiClient.get('/sites/reports/$siteId?pageNum=0&pageSize=1000');
    print(response);
    if (response.statusCode == 200) {
      print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
      var data = (response.data['data'] as List);
      print(data[0]);
      print(ReportModel.fromJson(data[0]));
      List<ReportModel> result = (response.data['data'] as List)
          .map<ReportModel>((json) => ReportModel.fromJson(json))
          .toList();
      return result;
    } else {
      throw Exception('Failed to load reports');
    }
  }
}
