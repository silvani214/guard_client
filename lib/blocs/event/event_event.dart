part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class FetchEvents extends EventEvent {
  final int id;

  FetchEvents({required this.id});

  @override
  List<Object?> get props => [id];
}

class RefreshEvents extends EventEvent {
  final int id;

  RefreshEvents({required this.id});

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
