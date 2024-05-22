part of 'site_bloc.dart';

abstract class SiteState extends Equatable {
  const SiteState();

  @override
  List<Object> get props => [];
}

class SiteInitial extends SiteState {}

class SiteLoading extends SiteState {}

class SiteLoaded extends SiteState {
  final List<SiteModel> sites;

  SiteLoaded({required this.sites});

  @override
  List<Object> get props => [sites];
}

class SiteError extends SiteState {
  final String message;

  SiteError({required this.message});

  @override
  List<Object> get props => [message];
}
