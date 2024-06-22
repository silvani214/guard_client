part of 'guard_bloc.dart';

abstract class GuardState extends Equatable {
  const GuardState();

  @override
  List<Object> get props => [];
}

class GuardInitial extends GuardState {}

class GuardLoading extends GuardState {}

class GuardListLoaded extends GuardState {
  final List<UserModel> guards;

  const GuardListLoaded({required this.guards});

  @override
  List<Object> get props => [guards];
}

class GuardError extends GuardState {
  final String message;
  GuardError({required this.message});
}
