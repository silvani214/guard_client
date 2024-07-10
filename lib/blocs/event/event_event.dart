part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class FetchEvents extends EventEvent {
  final int id;
  final int? pageNum;
  final DateTime? startDate;
  final DateTime? endDate;
  final Completer<List<EventModel>>? completer;

  FetchEvents(
      {required this.id,
      this.pageNum,
      this.startDate,
      this.endDate,
      this.completer});

  @override
  List<Object?> get props => [id, pageNum, startDate, endDate];
}

class RefreshEvents extends EventEvent {
  final int id;
  final DateTime? startDate;
  final DateTime? endDate;

  RefreshEvents({required this.id, this.startDate, this.endDate});

  @override
  List<Object?> get props => [id];
}

class GetEvent extends EventEvent {
  final int id;

  GetEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class CreateEvent extends EventEvent {
  final EventModel event;

  CreateEvent({required this.event});

  @override
  List<Object?> get props => [event];
}

class UpdateEvent extends EventEvent {
  final EventModel event;

  UpdateEvent({required this.event});

  @override
  List<Object?> get props => [event];
}
