import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/site_model.dart';
import '../../services/site_service.dart';

part 'site_event.dart';
part 'site_state.dart';

class SiteBloc extends Bloc<SiteEvent, SiteState> {
  List<SiteModel>? _cachedSiteList;
  final SiteService siteService;

  SiteBloc({required this.siteService}) : super(SiteInitial()) {
    on<FetchSites>(_onFetchSites);
    on<RefreshSites>(_onRefreshSites);
    on<GetSite>(_onGetSite);
    on<CreateSite>(_onCreateSite);
    on<UpdateSite>(_onUpdateSite);
  }

  Future<void> _onFetchSites(FetchSites event, Emitter<SiteState> emit) async {
    if (_cachedSiteList != null) {
      emit(SiteListLoaded(sites: _cachedSiteList!));
    } else {
      emit(SiteLoading());
      try {
        final sites = await siteService.getAllSites();
        _cachedSiteList = sites;
        emit(SiteListLoaded(sites: sites));
      } catch (e) {
        emit(SiteError(message: e.toString()));
      }
    }
  }

  Future<void> _onRefreshSites(
      RefreshSites event, Emitter<SiteState> emit) async {
    emit(SiteLoading());
    try {
      final sites = await siteService.getAllSites();
      _cachedSiteList = sites;
      emit(SiteListLoaded(sites: sites));
    } catch (e) {
      emit(SiteError(message: e.toString()));
    }
  }

  Future<void> _onGetSite(GetSite event, Emitter<SiteState> emit) async {
    emit(SiteDetailLoading());
    try {
      final site = await siteService.getSite(event.id);
      emit(SiteDetailLoaded(site: site));
    } catch (e) {
      emit(SiteError(message: e.toString()));
    }
  }

  Future<void> _onCreateSite(CreateSite event, Emitter<SiteState> emit) async {
    try {
      await siteService.addSite(event.site);
      _cachedSiteList =
          await siteService.getAllSites(); // Refresh the site list cache
      emit(SiteListLoaded(
          sites: _cachedSiteList!)); // Emit updated site list state
    } catch (e) {
      emit(SiteError(message: e.toString()));
    }
  }

  Future<void> _onUpdateSite(UpdateSite event, Emitter<SiteState> emit) async {
    try {
      await siteService.editSite(event.site);
      _cachedSiteList =
          await siteService.getAllSites(); // Refresh the site list cache
      emit(SiteListLoaded(
          sites: _cachedSiteList!)); // Emit updated site list state
    } catch (e) {
      emit(SiteError(message: e.toString()));
    }
  }
}
