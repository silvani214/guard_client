import 'package:guard_client/models/user_model.dart';
import 'package:guard_client/services/auth_service.dart';

import '../models/event_model.dart';
import '../services/api_client.dart';
import '../utils/util.dart';

class EventRepository {
  final ApiClient apiClient;

  EventRepository({required this.apiClient});

  Future<List<EventModel>> fetchEvents(int id,
      {int? pageNum, DateTime? startDate, DateTime? endDate}) async {
    try {
      final startDateStr =
          startDate != null ? Utils.formatDateToString(startDate) : null;
      final endDateStr =
          endDate != null ? Utils.formatDateToString(endDate) : null;

      final response = (startDateStr != null && endDateStr != null)
          ? await apiClient.get(
              '/events/?siteId=$id&pageNum=${(pageNum! / 10).floor()}&pageSize=10&startDate=$startDateStr&endDate=$endDateStr')
          : await apiClient.get('/events/?siteId=$id&pageNum=0&pageSize=10');

      List<EventModel> events = (response.data['data'] as List)
          .map((event) => EventModel.fromJson(event))
          .toList();
      return events;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch event list');
    }
  }

  Future<EventModel> getEvent(int id) async {
    try {
      final response = await apiClient.get('/events/$id');
      EventModel event = EventModel.fromJson(response.data['data']);
      return event;
    } catch (e) {
      throw Exception('Failed to get an event');
    }
  }

  Future<void> createEvent(EventModel event) async {
    await apiClient.post('/events', data: event.toJson());
  }

  Future<void> updateEvent(EventModel event) async {
    await apiClient.post('/events/${event.id}', data: event.toJson());
  }
}
