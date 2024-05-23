part of 'site_bloc.dart';

abstract class SiteState extends Equatable {
  const SiteState();

  @override
  List<Object?> get props => [];
}

class SiteInitial extends SiteState {}

class SiteLoading extends SiteState {}

class SiteListLoaded extends SiteState {
  final List<SiteModel> sites;

  SiteListLoaded({required this.sites});

  @override
  List<Object?> get props => [sites];
}

class SiteDetailLoading extends SiteState {}

class SiteDetailLoaded extends SiteState {
  final SiteModel site;

  SiteDetailLoaded({required this.site});

  @override
  List<Object?> get props => [site];
}

class SiteError extends SiteState {
  final String message;

  SiteError({required this.message});

  @override
  List<Object?> get props => [message];
}
