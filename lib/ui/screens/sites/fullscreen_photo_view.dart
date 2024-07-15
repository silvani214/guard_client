import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../../models/report_model.dart';
import '../../../utils/constants.dart';

class FullScreenPhotoView extends StatefulWidget {
  final List<Photo> photos;
  final int initialIndex;

  FullScreenPhotoView({required this.photos, required this.initialIndex});

  @override
  _FullScreenPhotoViewState createState() => _FullScreenPhotoViewState();
}

class _FullScreenPhotoViewState extends State<FullScreenPhotoView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: widget.photos.length,
        builder: (context, index) {
          final photo = widget.photos[index];
          return PhotoViewGalleryPageOptions(
            imageProvider:
                NetworkImage('${AppConstants.baseUrl}/images/${photo.url}'),
            heroAttributes: PhotoViewHeroAttributes(tag: photo.url),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}
