import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import 'package:get_it/get_it.dart';
import 'package:guard_client/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel?> userFuture;
  final getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    userFuture = getIt<AuthService>().getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading profile'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('No user data available'),
            );
          } else {
            UserModel user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(context, user),
                  _buildProfileDetails(context, user),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              user.firstName != null
                  ? user.firstName![0] + user.lastName![0]
                  : "",
              style: TextStyle(
                fontSize: 40,
                color: Colors.blueAccent,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            user.firstName != null
                ? '${user.firstName} ${user.firstName}'
                : "N/A",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildDetailCard(
            icon: Icons.person,
            title: 'First Name',
            content: user.firstName ?? 'N/A',
          ),
          SizedBox(height: 16),
          _buildDetailCard(
            icon: Icons.person_outline,
            title: 'Last Name',
            content: user.lastName ?? 'N/A',
          ),
          SizedBox(height: 16),
          _buildDetailCard(
            icon: Icons.email,
            title: 'Email',
            content: user.email,
          ),
          SizedBox(height: 16),
          // Add more details as needed
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
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
          ],
        ),
      ),
    );
  }
}
