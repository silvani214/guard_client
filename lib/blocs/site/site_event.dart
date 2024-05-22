part of 'site_bloc.dart';

abstract class SiteEvent extends Equatable {
  const SiteEvent();

  @override
  List<Object> get props => [];
}

class FetchSites extends SiteEvent {}

class CreateSite extends SiteEvent {
  final SiteModel site;

  CreateSite({required this.site});

  @override
  List<Object> get props => [site];
}

class UpdateSite extends SiteEvent {
  final SiteModel site;

  UpdateSite({required this.site});

  @override
  List<Object> get props => [site];
}
