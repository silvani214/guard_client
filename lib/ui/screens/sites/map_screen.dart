import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng location;

  MapScreen({this.location = const LatLng(37.7749, -122.4194)});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.location;
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  void _onConfirm() {
    Navigator.of(context).pop(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedLocation!,
          zoom: 14,
        ),
        onTap: _onMapTap,
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('selected-location'),
                  position: _selectedLocation!,
                ),
              }
            : {},
      ),
    );
  }
}
