import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/photo_model.dart';
import '../../../models/site_model.dart';
import '../../../utils/constants.dart';
import 'photo_view_gallery_screen.dart';

class PhotoDetailScreen extends StatelessWidget {
  final PhotoModel photo;

  PhotoDetailScreen({required this.photo});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('yyyy-MM-dd hh:mm').format(photo.timestamp);

    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoViewGalleryScreen(photo: photo),
                  ),
                );
              },
              child: Hero(
                tag: 'photo_${photo.url}',
                child: Image.network(
                  '${AppConstants.baseUrl}/images/${photo.url}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildInfoSection(
              context,
              label: 'Timestamp',
              content: formattedDate,
            ),
            _buildInfoSection(
              context,
              label: 'Site Name',
              content: photo.site.name,
            ),
            _buildInfoSection(
              context,
              label: 'Site Address',
              content: photo.site.address,
            ),
            _buildInfoSection(
              context,
              label: 'Guard Name',
              content: '${photo.guard.firstname} ${photo.guard.lastname}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context,
      {required String label, required String content}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
