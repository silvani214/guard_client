import 'package:guard_client/models/user_model.dart';
import 'package:guard_client/services/auth_service.dart';
import 'dart:async';

import '../models/report_model.dart';
import '../services/api_client.dart';
import '../utils/util.dart';

class ReportRepository {
  final ApiClient apiClient;

  ReportRepository({required this.apiClient});

  Future<List<ReportModel>> fetchReports(int id,
      {int? pageNum, DateTime? startDate, DateTime? endDate}) async {
    try {
      final startDateStr =
          startDate != null ? Utils.formatDateToString(startDate) : null;
      final endDateStr =
          endDate != null ? Utils.formatDateToString(endDate) : null;
      print(
          '/sites/reports/$id?pageNum=${(pageNum! / 10).floor()}&pageSize=10&startDate=$startDateStr&endDate=$endDateStr');
      final response = (startDateStr != null && endDateStr != null)
          ? await apiClient.get(
              '/sites/reports/$id?pageNum=${(pageNum! / 10).floor()}&pageSize=10&startDate=$startDateStr&endDate=$endDateStr')
          : await apiClient.get('/sites/reports$id?pageNum=0&pageSize=10');
      print(response.data);
      List<ReportModel> Reports = (response.data['data'] as List)
          .map((Report) => ReportModel.fromJson(Report))
          .toList();
      return Reports;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch Report list');
    }
  }

  Future<ReportModel> getReport(int id) async {
    try {
      final response = await apiClient.get('/Reports/$id');
      ReportModel Report = ReportModel.fromJson(response.data['data']);
      return Report;
    } catch (e) {
      throw Exception('Failed to get an Report');
    }
  }
}
