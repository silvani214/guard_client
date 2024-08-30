import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:guard_client/repositories/auth_repository.dart';
import 'package:guard_client/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../../../models/user_model.dart';
import 'package:guard_client/services/api_client.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel?> userFuture;
  final getIt = GetIt.instance;
  late ApiClient _apiClient;

  UserModel? user;

  @override
  void initState() {
    super.initState();
    userFuture = getIt<AuthService>().getUserDetail();
    _apiClient = getIt<ApiClient>();
    userFuture.then((userData) {
      setState(() {
        user = userData;
      });
    });
  }

  Future<void> _openEditDialog(String field, String value) async {
    final TextEditingController controller = TextEditingController(text: value);

    final updatedValue = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit $field',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: field,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(controller.text);
                    },
                    child: Text('OK'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (updatedValue != null && updatedValue.isNotEmpty) {
      setState(() {
        user = user?.copyWith(
            firstName: field == 'First Name' ? updatedValue : user?.firstName,
            lastName: field == 'Last Name' ? updatedValue : user?.lastName,
            email: field == 'Email' ? updatedValue : user?.email,
            address: field == 'Address' ? updatedValue : user?.address,
            phone: field == 'Phone' ? updatedValue : user?.phone,
            position: field == 'Position' ? updatedValue : user?.position,
            company: field == 'Company' ? updatedValue : user?.company,
            role: field == 'Role' ? updatedValue : user?.role,
            gender: field == 'Gender' ? updatedValue : user?.gender,
            password: '123456');
      });
      print(user);
      getIt<AuthService>().saveUserDetail(user!);
      final success = await getIt<AuthRepository>().updateUserDetail(user!);

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  Future<void> _openReportBugDialog() async {
    final TextEditingController controller = TextEditingController();

    final bugReport = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Bug',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Describe the bug',
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(controller.text);
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (bugReport != null && bugReport.isNotEmpty) {
      try {
        await _apiClient.put('/setting/bugs', data: bugReport);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bug reported successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to report bug')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 247, 250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          surfaceTintColor: Theme.of(context).primaryColor,
          backgroundColor: Color.fromARGB(255, 245, 247, 250),
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              'Profile',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon:
                  Icon(Icons.more_vert, color: Theme.of(context).primaryColor),
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 40, 0, 0),
                  items: [
                    PopupMenuItem<String>(
                      value: 'report_bug',
                      child: Text('Report Bug'),
                    ),
                  ],
                ).then((value) {
                  if (value == 'report_bug') {
                    _openReportBugDialog();
                  }
                });
              },
            ),
          ],
        ),
      ),
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEditableInfoSection(
                      context,
                      label: 'First Name',
                      content: user?.firstName ?? 'N/A',
                    ),
                    _buildEditableInfoSection(
                      context,
                      label: 'Last Name',
                      content: user?.lastName ?? 'N/A',
                    ),
                    _buildEditableInfoSection(
                      context,
                      label: 'Email',
                      content: user?.email ?? 'N/A',
                    ),
                    _buildEditableInfoSection(
                      context,
                      label: 'Address',
                      content: user?.address ?? 'N/A',
                    ),
                    _buildEditableInfoSection(
                      context,
                      label: 'Phone',
                      content: user?.phone ?? 'N/A',
                    ),
                    _buildEditableInfoSection(
                      context,
                      label: 'Position',
                      content: user?.position ?? 'N/A',
                    ),
                    _buildEditableInfoSection(
                      context,
                      label: 'Company',
                      content: user?.company ?? 'N/A',
                    ),
                    _buildEditableInfoSection(
                      context,
                      label: 'Role',
                      content: user?.role ?? 'N/A',
                    ),
                    _buildEditableInfoSection(
                      context,
                      label: 'Gender',
                      content: user?.gender ?? 'N/A',
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEditableInfoSection(BuildContext context,
      {required String label, required String content}) {
    return GestureDetector(
      onTap: () => _openEditDialog(label, content),
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Icon(Icons.edit, color: Theme.of(context).primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
