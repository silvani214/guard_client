import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../models/visitor_model.dart';
import '../../../utils/constants.dart';

class VisitorDetailScreen extends StatelessWidget {
  final VisitorModel visitor;

  VisitorDetailScreen({required this.visitor});

  @override
  Widget build(BuildContext context) {
    final formattedDate = visitor.timestamp != null
        ? DateFormat('yyyy-MM-dd').format(visitor.timestamp!)
        : 'N/A';

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 247, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 247, 250),
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Visitor Details',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: visitor.url != null
                  ? CachedNetworkImage(
                      imageUrl: '${AppConstants.baseUrl}/images/${visitor.url}',
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 50,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) => CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: SpinKitCircle(
                          color: Theme.of(context).primaryColor,
                          size: 50.0,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          _buildInfoSection(
            context,
            label: 'Full Name',
            content: visitor.fullname,
          ),
          _buildInfoSection(
            context,
            label: 'Company',
            content: visitor.company ?? 'N/A',
          ),
          _buildInfoSection(
            context,
            label: 'License Plate',
            content: visitor.licenseplate ?? 'N/A',
          ),
          _buildInfoSection(
            context,
            label: 'Visit Date',
            content: formattedDate,
          ),
          _buildInfoSection(
            context,
            label: 'Site Name',
            content: visitor.site.name,
          ),
          _buildInfoSection(
            context,
            label: 'Site Address',
            content: visitor.site.address,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context,
      {required String label, required String content, Widget? child}) {
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
          child ??
              Text(
                content,
                style: TextStyle(fontSize: 16),
              ),
        ],
      ),
    );
  }
}
