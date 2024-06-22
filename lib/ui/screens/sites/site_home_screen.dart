import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../sitemap/map.dart';
import '../event/event_screen.dart';
import '../chat/chat_room.dart';
import './site_detail_screen.dart';
import 'package:guard_client/ui/screens/chat/chat_screen.dart';
import '../../../models/site_model.dart';

class SiteHomeScreen extends StatefulWidget {
  final SiteModel site;

  SiteHomeScreen({required this.site});

  @override
  _SiteHomeScreenState createState() => _SiteHomeScreenState();
}

class _SiteHomeScreenState extends State<SiteHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      SiteDetailScreen(site: widget.site),
      SiteMapScreen(siteId: widget.site.id),
      ChatRoom(), // Placeholder for the chat screen
      EventScreen(siteId: widget.site.id), // Placeholder for the event screen
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Event',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
