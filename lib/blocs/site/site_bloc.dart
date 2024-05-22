import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/site_model.dart';
import '../../services/site_service.dart';

part 'site_event.dart';
part 'site_state.dart';

class SiteBloc extends Bloc<SiteEvent, SiteState> {
  final SiteService siteService;

  SiteBloc({required this.siteService}) : super(SiteInitial()) {
    on<FetchSites>(_onFetchSites);
    on<CreateSite>(_onCreateSite);
    on<UpdateSite>(_onUpdateSite);
  }

  Future<void> _onFetchSites(FetchSites event, Emitter<SiteState> emit) async {
    emit(SiteLoading());
    try {
      final sites = await siteService.getAllSites();
      emit(SiteLoaded(sites: sites));
    } catch (e) {
      emit(SiteError(message: e.toString()));
    }
  }

  Future<void> _onCreateSite(CreateSite event, Emitter<SiteState> emit) async {
    try {
      await siteService.addSite(event.site);
      add(FetchSites()); // Refresh the site list after adding a site
    } catch (e) {
      emit(SiteError(message: e.toString()));
    }
  }

  Future<void> _onUpdateSite(UpdateSite event, Emitter<SiteState> emit) async {
    try {
      await siteService.editSite(event.site);
      add(FetchSites()); // Refresh the site list after updating a site
    } catch (e) {
      emit(SiteError(message: e.toString()));
    }
  }
}
