import 'package:guard_client/services/api_client.dart';
import 'package:guard_client/models/schedule_model.dart';

class ScheduleRepository {
  final ApiClient apiClient;
  ScheduleRepository({required this.apiClient});

  Future<List<ScheduleModel>> fetchSchedules(
    int siteId, {
    int? pageNum,
  }) async {
    try {
      final response = await apiClient.get('/schedule/?siteId=$siteId');
      print(response.data['data']);

      List<ScheduleModel> schedules = (response.data['data'] as List)
          .map((schedule) => ScheduleModel.fromJson(schedule))
          .toList();

      return schedules;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch schedule list');
    }
  }

  Future<void> updateSchedule(
      int siteId, List<ScheduleModel> appointmentList) async {
    try {
      final request = {
        "siteId": siteId,
        "appointmentList": appointmentList.map((e) => e.toJson()).toList(),
      };

      await apiClient.post('/schedule/', data: request);
    } catch (e) {
      print(e);
      throw Exception('Failed to update schedule');
    }
  }
}
