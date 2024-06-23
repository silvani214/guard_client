import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/site_model.dart';
import '../sitemap/map.dart';
import './map_screen.dart';

class SiteDetailScreen extends StatelessWidget {
  final SiteModel site;

  SiteDetailScreen({required this.site});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Site Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SiteDetail(site: site),
      ),
    );
  }
}

class SiteDetail extends StatelessWidget {
  final SiteModel site;

  SiteDetail({required this.site});

  @override
  Widget build(BuildContext context) {
    String name = site.name;
    String description = site.description ?? 'N/A';
    String address = site.address ?? 'No address provided';
    String location = '${site.location.latitude}\n${site.location.longitude}';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard(
            context,
            icon: Icons.location_city,
            title: 'Name',
            content: name,
          ),
          SizedBox(height: 16),
          _buildDetailCard(
            context,
            icon: Icons.description,
            title: 'Description',
            content: description,
          ),
          SizedBox(height: 16),
          _buildDetailCard(
            context,
            icon: Icons.home,
            title: 'Address',
            content: address,
            isAddress: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    location:
                        LatLng(site.location.latitude, site.location.longitude),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    bool isAddress = false,
    VoidCallback? onPressed,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.black12),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            if (isAddress && onPressed != null)
              IconButton(
                icon: Icon(Icons.map, color: Theme.of(context).primaryColor),
                onPressed: onPressed,
              ),
          ],
        ),
      ),
    );
  }
}
