import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/photo_model.dart';
import '../services/api_client.dart';
import '../utils/util.dart';

class PhotoRepository {
  final ApiClient apiClient;

  PhotoRepository({required this.apiClient});

  Future<List<PhotoModel>> fetchPhotos(int siteId,
      {int pageNum = 0, DateTime? startDate, DateTime? endDate}) async {
    try {
      final startDateStr =
          startDate != null ? Utils.formatDateToString(startDate) : null;
      final endDateStr =
          endDate != null ? Utils.formatDateToString(endDate) : null;
      final response = (startDateStr != null && endDateStr != null)
          ? await apiClient.get(
              '/sites/photos/$siteId?pageNum=$pageNum&pageSize=10&startDate=$startDateStr&endDate=$endDateStr')
          : await apiClient
              .get('/sites/photos/$siteId?pageNum=$pageNum&pageSize=10');

      print(response);

      List<PhotoModel> photos = (response.data['data'] as List)
          .map((photo) => PhotoModel.fromJson(photo['photo']))
          .toList();
      return photos;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch photo list');
    }
  }

  Future<PhotoModel> getPhoto(int id) async {
    try {
      final response = await apiClient.get('/photos/$id');
      PhotoModel photo = PhotoModel.fromJson(response.data['data']);
      return photo;
    } catch (e) {
      throw Exception('Failed to get a photo');
    }
  }
}
