import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/event_model.dart';
import '../../services/event_service.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  List<EventModel>? _cachedEventList;
  final EventService eventService;

  EventBloc({required this.eventService}) : super(EventInitial()) {
    on<FetchEvents>(_onFetchEvents);
    on<RefreshEvents>(_onRefreshEvents);
    on<GetEvent>(_onGetEvent);
  }

  Future<void> _onFetchEvents(
      FetchEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final events = await eventService.getAllEvents(event.id);
      _cachedEventList = events;
      emit(EventListLoaded(events: events));
    } catch (e) {
      emit(EventError(message: e.toString()));
    }
  }

  Future<void> _onRefreshEvents(
      RefreshEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final events = await eventService.getAllEvents(event.id);
      _cachedEventList = events;
      emit(EventListLoaded(events: events));
    } catch (e) {
      emit(EventError(message: e.toString()));
    }
  }

  Future<void> _onGetEvent(GetEvent event, Emitter<EventState> emit) async {
    emit(EventDetailLoading());
    try {
      final eventDetail = await eventService.getEvent(event.id);
      emit(EventDetailLoaded(event: eventDetail));
    } catch (e) {
      emit(EventError(message: e.toString()));
    }
  }
}
