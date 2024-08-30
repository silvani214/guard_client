import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../../../models/photo_model.dart';
import '../../../utils/constants.dart';
import 'package:intl/intl.dart';

class PhotoViewDetailScreen extends StatelessWidget {
  final PhotoModel photo;

  PhotoViewDetailScreen({required this.photo});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('yyyy-MM-dd hh:mm').format(photo.timestamp);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: PhotoView(
              imageProvider: NetworkImage(
                '${AppConstants.baseUrl}/images/${photo.url}',
              ),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: 'photo_${photo.url}'),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              color: Color(0x44444466),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Timestamp: $formattedDate',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Site Name: ${photo.site?.name}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Site Address: ${photo.site?.address}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Guard Name: ${photo.guard.firstname} ${photo.guard.lastname}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Title: ${photo.title}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
