import '../models/site_model.dart';
import '../repositories/site_repository.dart';

class SiteService {
  final SiteRepository siteRepository;

  SiteService({required this.siteRepository});

  Future<List<SiteModel>> getAllSites() async {
    try {
      return await siteRepository.fetchSites();
    } catch (e) {
      // Handle errors appropriately in your app
      rethrow;
    }
  }

  Future<SiteModel> getSite(int id) async {
    try {
      return await siteRepository.getSite(id);
    } catch (e) {
      // Handle errors appropriately in your app
      rethrow;
    }
  }

  Future<void> addSite(SiteModel site) async {
    try {
      await siteRepository.createSite(site);
    } catch (e) {
      // Handle errors appropriately in your app
      rethrow;
    }
  }

  Future<void> editSite(SiteModel site) async {
    try {
      await siteRepository.updateSite(site);
    } catch (e) {
      // Handle errors appropriately in your app
      rethrow;
    }
  }
}
