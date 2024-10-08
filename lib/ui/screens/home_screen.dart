import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:guard_client/repositories/auth_repository.dart';
import 'package:guard_client/ui/screens/event/event_screen.dart';
import 'package:guard_client/ui/screens/profile/profile_screen.dart';
import 'package:guard_client/ui/screens/report/report_screen.dart';
import 'package:guard_client/ui/screens/sitemap/map.dart';
import './chat/chat_room.dart';
import 'package:guard_client/ui/screens/dashboard/dashboard_screen.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const List<TabItem> items = [
  TabItem(
    icon: Icons.dashboard_outlined,
    title: 'Dashbaord',
  ),
  TabItem(
    icon: Icons.map_outlined,
    title: 'Map',
  ),
  TabItem(
    icon: Icons.chat_outlined,
    title: 'Chat',
  ),
  TabItem(
    icon: Icons.account_box_outlined,
    title: 'Profile',
  ),
  // TabItem(
  //   icon: Icons.report_outlined,
  //   title: 'Report',
  // ),
];

final getIt = GetIt.instance;

class _HomeScreenState extends State<HomeScreen> {
  var authRepo = getIt<AuthRepository>();

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    SiteMapScreen(),
    ChatRoom(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    saveToken();
  }

  void saveToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    authRepo.saveToken(token ?? "");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    Color colorSelected = Color.fromARGB(255, 25, 74, 151);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 12,
              blurRadius: 15,
              offset: Offset(0, 8), // changes position of shadow
            ),
          ],
        ),
        child: BottomBarInspiredFancy(
          items: items,
          backgroundColor: Colors.white,
          color: color,
          colorSelected: colorSelected,
          indexSelected: _selectedIndex,
          styleIconFooter: StyleIconFooter.dot,
          iconSize: 32,
          titleStyle: TextStyle(
              fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w600),
          onTap: (int index) => setState(() {
            _selectedIndex = index;
          }),
        ),
      ),
    );
  }
}
