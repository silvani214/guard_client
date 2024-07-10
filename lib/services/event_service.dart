import '../models/event_model.dart';
import '../repositories/event_repository.dart';

class EventService {
  final EventRepository eventRepository;

  EventService({required this.eventRepository});

  Future<List<EventModel>> getAllEvents(
      int id, int? pageNum, DateTime? startDate, DateTime? endDate) async {
    try {
      return await eventRepository.fetchEvents(id,
          pageNum: pageNum, startDate: startDate, endDate: endDate);
    } catch (e) {
      throw Exception('Failed to fetch events');
    }
  }

  Future<EventModel> getEvent(int id) async {
    try {
      return await eventRepository.getEvent(id);
    } catch (e) {
      throw Exception('Failed to fetch event');
    }
  }

  Future<void> addEvent(EventModel event) async {
    try {
      await eventRepository.createEvent(event);
    } catch (e) {
      throw Exception('Failed to add event');
    }
  }

  Future<void> editEvent(EventModel event) async {
    try {
      await eventRepository.updateEvent(event);
    } catch (e) {
      throw Exception('Failed to update event');
    }
  }
}
