import '../models/site_model.dart';
import '../services/api_client.dart';
import 'dart:convert';

class SiteRepository {
  final ApiClient apiClient;

  SiteRepository({required this.apiClient});

  Future<List<SiteModel>> fetchSites() async {
    final response = await apiClient.get('/sites/client/102');
    List<SiteModel> sites = (response.data as List)
        .map((site) => SiteModel.fromJson(site))
        .toList();
    return sites;
  }

  Future<SiteModel> getSite(int id) async {
    final response = await apiClient.get('/sites/$id');
    Map<String, dynamic> originalMap = response.data;
    final Map<String, dynamic> data = {
      ...originalMap['site'],
      'hitPointsList': originalMap['hitPointsList']
    };
    SiteModel site = SiteModel.fromJson(data);

    return site;
  }

  Future<void> createSite(SiteModel site) async {
    await apiClient.post('/sites', data: site.toJson());
  }

  Future<void> updateSite(SiteModel site) async {
    await apiClient.post('/sites/${site.name}', data: site.toJson());
  }
}
