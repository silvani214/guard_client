import 'package:guard_client/models/visitor_model.dart';
import 'package:guard_client/services/api_client.dart';
import 'package:guard_client/utils/util.dart';

class VisitorRepository {
  final ApiClient apiClient;
  VisitorRepository({required this.apiClient});

  Future<List<VisitorModel>> fetchVisitors(
    int siteId, {
    int? pageNum,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final startDateStr =
          startDate != null ? Utils.formatDateToString(startDate) : null;
      final endDateStr =
          endDate != null ? Utils.formatDateToString(endDate) : null;

      final response = (startDateStr != null && endDateStr != null)
          ? await apiClient.get(
              '/sites/visitors/$siteId?pageNum=${(pageNum! / 10).floor()}&pageSize=10&startDate=$startDateStr&endDate=$endDateStr')
          : await apiClient.get(
              '/sites/visitors/$siteId?pageNum=${(pageNum! / 10).floor()}&pageSize=10');

      print(response.data['data']);

      List<VisitorModel> visitors = (response.data['data'] as List)
          .map((visitor) => VisitorModel.fromJson(visitor['visitor']))
          .toList();

      return visitors;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch visitor list');
    }
  }

  Future<VisitorModel> getVisitor(int id) async {
    try {
      final response = await apiClient.get('/visitors/$id');
      VisitorModel visitor = VisitorModel.fromJson(response.data['data']);
      return visitor;
    } catch (e) {
      throw Exception('Failed to get a visitor');
    }
  }
}
