part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventListLoaded extends EventState {
  final List<EventModel> events;

  EventListLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class EventDetailLoading extends EventState {}

class EventDetailLoaded extends EventState {
  final EventModel event;

  EventDetailLoaded({required this.event});

  @override
  List<Object?> get props => [event];
}

class EventError extends EventState {
  final String message;

  EventError({required this.message});

  @override
  List<Object?> get props => [message];
}
