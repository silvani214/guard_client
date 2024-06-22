part of 'guard_bloc.dart';

abstract class GuardEvent extends Equatable {
  const GuardEvent();

  @override
  List<Object> get props => [];
}

class FetchGuards extends GuardEvent {}

class RefreshGuards extends GuardEvent {}
