import 'package:flutter/material.dart';
import '../../../models/report_model.dart';

class ReportDetailScreen extends StatelessWidget {
  final ReportModel report;

  ReportDetailScreen({required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 247, 250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0), // Set the custom height
        child: AppBar(
          surfaceTintColor: Theme.of(context).primaryColor,
          backgroundColor: Color.fromARGB(255, 245, 247, 250),
          elevation: 0, // Remove shadow
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Report Details',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhotoList(report.photoList),
            SizedBox(height: 16),
            _buildInfoSection(
              context,
              label: 'Nature',
              content: report.nature,
            ),
            _buildInfoSection(
              context,
              label: 'Description',
              content: report.description,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoList(List<Photo> photos) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'http://35.183.88.228:8080/api/images/${photo.url}',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
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
