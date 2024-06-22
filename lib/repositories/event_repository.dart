import 'package:guard_client/models/user_model.dart';
import 'package:guard_client/services/auth_service.dart';

import '../models/event_model.dart';
import '../services/api_client.dart';

class EventRepository {
  final ApiClient apiClient;

  EventRepository({required this.apiClient});

  Future<List<EventModel>> fetchEvents(int id) async {
    try {
      final response = await apiClient.get('/events/?siteId=$id');
      List<EventModel> events = (response.data['data'] as List)
          .map((event) => EventModel.fromJson(event))
          .toList();
      return events;
    } catch (e) {
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
