import '../models/site_model.dart';
import '../services/api_client.dart';

class SiteRepository {
  final ApiClient apiClient;

  SiteRepository({required this.apiClient});

  Future<List<SiteModel>> fetchSites() async {
    final response = await apiClient.get('/sites/client/102');
    print(response);
    List<SiteModel> sites = (response.data as List)
        .map((site) => SiteModel.fromJson(site))
        .toList();
    return sites;
  }

  Future<void> createSite(SiteModel site) async {
    await apiClient.post('/sites', data: site.toJson());
  }

  Future<void> updateSite(SiteModel site) async {
    await apiClient.post('/sites/${site.name}', data: site.toJson());
  }
}
