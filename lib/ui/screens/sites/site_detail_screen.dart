import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guard_client/models/site_model.dart';
import 'package:guard_client/ui/screens/event/event_screen.dart';
import 'package:guard_client/ui/screens/sites/site_photo_screen.dart';
import 'package:guard_client/ui/screens/sites/site_visitor_screen.dart';
import 'package:guard_client/ui/screens/sites/site_report_screen.dart';
import './schedule_list.dart';

class SiteDetailScreen extends StatelessWidget {
  final SiteModel site;

  SiteDetailScreen({required this.site});

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
              icon:
                  Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Detail',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(
              context,
              label: 'Name',
              content: site.name,
            ),
            _buildInfoSection(
              context,
              label: 'Description',
              content: site.description ?? 'No Description',
            ),
            _buildInfoSection(
              context,
              label: 'Address',
              content: site.address ?? 'No Address Available',
              icon: Icons.map,
              onIconPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text('Map'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      body: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              site.location.latitude, site.location.longitude),
                          zoom: 14.0,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId(site.name),
                            position: LatLng(site.location.latitude,
                                site.location.longitude),
                            infoWindow: InfoWindow(title: site.name),
                          ),
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildVerticalButton(
                  context,
                  icon: Icons.person,
                  label: 'Visitor',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VisitorScreen(siteId: site.id),
                      ),
                    );
                  },
                ),
                SizedBox(width: 24), // Space between buttons
                _buildVerticalButton(
                  context,
                  icon: Icons.report,
                  label: 'Report',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReportScreen(siteId: site.id),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildVerticalButton(
                  context,
                  icon: Icons.local_activity,
                  label: 'Activity',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EventScreen(siteId: site.id, isDetail: true),
                      ),
                    );
                  },
                ),
                SizedBox(width: 24),
                _buildVerticalButton(
                  context,
                  icon: Icons.photo_size_select_actual,
                  label: 'Photo Lib',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PhotoListScreen(siteId: site.id),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(width: 24),
            Expanded(
              child: ScheduleList(siteId: site.id), // Add this line
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context,
      {required String label,
      required String content,
      IconData? icon,
      VoidCallback? onIconPressed}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
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
          ),
          if (icon != null)
            IconButton(
              icon: Icon(icon, color: Theme.of(context).primaryColor),
              onPressed: onIconPressed,
            ),
        ],
      ),
    );
  }

  Widget _buildVerticalButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(100, 80), // Adjust size to fit the icon and label
        foregroundColor: Colors.white,
        padding: EdgeInsets.all(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
