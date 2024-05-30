import 'package:guard_client/models/user_model.dart';
import 'package:guard_client/services/auth_service.dart';

import '../models/site_model.dart';
import '../services/api_client.dart';

class SiteRepository {
  final ApiClient apiClient;

  SiteRepository({required this.apiClient});

  Future<List<SiteModel>> fetchSites() async {
    UserModel? user = await apiClient.authService.getUserDetail();
    int id = user!.id;
    try {
      final response = await apiClient.get('/sites/');
      print(response.data['data']);
      List<SiteModel> sites = (response.data['data'] as List)
          .map((site) => SiteModel.fromJson(site))
          .toList();
      return sites;
    } catch (e) {
      throw Exception('Failed to fetch site list');
    }
  }

  Future<SiteModel> getSite(int id) async {
    try {
      final response = await apiClient.get('/sites/$id');
      Map<String, dynamic> originalMap = response.data;
      final Map<String, dynamic> data = {
        ...originalMap['data']['site'],
        'hitPointsList': originalMap['data']['hitPointsList']
      };
      SiteModel site = SiteModel.fromJson(data);

      return site;
    } catch (e) {
      throw Exception('Failed to get a site');
    }
  }

  Future<void> createSite(SiteModel site) async {
    await apiClient.post('/sites', data: site.toJson());
  }

  Future<void> updateSite(SiteModel site) async {
    await apiClient.post('/sites/${site.name}', data: site.toJson());
  }
}
