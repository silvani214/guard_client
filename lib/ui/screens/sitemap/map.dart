import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:guard_client/blocs/site/site_bloc.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class SiteMapScreen extends StatefulWidget {
  final int siteId = 0;

  @override
  _SiteMapScreenState createState() => _SiteMapScreenState();
}

class _SiteMapScreenState extends State<SiteMapScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('locations');
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  late LatLng _sitePosition;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Completer<void> _signInCompleter = Completer<void>();
  final Completer<void> _mapControllerCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    _sitePosition =
        LatLng(45.427675000001365, -108.40590330000137); // Default position

    _signInAndFetchLocation();
//    context.read<SiteBloc>().add(GetSite(id: widget.siteId));
    context.read<SiteBloc>().add(RefreshSites());
    _runFunctionAfterBothComplete();
  }

  Future<void> _signInAndFetchLocation() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: 'client@gmail.com',
        password: '123456',
      );
      if (userCredential.user != null) {
        _signInCompleter.complete();
      }
    } catch (e) {
      _signInCompleter.completeError(e);
      print('Failed to sign in: $e');
    }
  }

  void _fetchLocation() {
    _databaseReference.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.exists) {
        var data = snapshot.value as List?;
        if (data != null && data.isNotEmpty) {
          var email = data[1]['email'];
          var latitude = data[1]['latitude'];
          var longitude = data[1]['longitude'];
          if (email == 'guard@test.com') {
            setState(() {
              _markers.add(
                Marker(
                  markerId: MarkerId(email),
                  position: LatLng(latitude, longitude),
                  infoWindow: InfoWindow(title: email),
                ),
              );
            });
          }
        }
      }
    });
  }

  void _runFunctionAfterBothComplete() {
    Future.wait([
      _signInCompleter.future,
      BlocProvider.of<SiteBloc>(context)
          .stream
          .firstWhere((state) => state is SiteListLoaded),
      _mapControllerCompleter.future,
    ]).then((results) {
      final siteState = results[1] as SiteListLoaded;
      _centerMapAndAddHitPoints(siteState);
      _fetchLocation();
    }).catchError((error) {
      print('Error: $error');
    });
  }

  void _centerMapAndAddHitPoints(SiteListLoaded state) {

    var siteList = state.sites;
    LatLngBounds bounds;

    Set<Marker> newMarkers = {};
    Set<Circle> newCircles = {};

    for (var site in siteList) {
      LatLng sitePosition =
          LatLng(site.location.latitude, site.location.longitude);

      newCircles.add(
        Circle(
          circleId: CircleId('siteCircle_${site.id}'),
          center: sitePosition,
          radius: 1000,
          fillColor: Colors.red.withOpacity(0.5),
          strokeColor: Colors.red,
          strokeWidth: 1,
        ),
      );

      newMarkers.add(
        Marker(
          markerId: MarkerId('site_${site.id}'),
          position: sitePosition,
          infoWindow: InfoWindow(title: site.name),
        ),
      );
    }

    setState(() {
      _circles = newCircles;
      _markers = newMarkers;
    });

    if (siteList.isNotEmpty) {
      bounds = _createBoundsFromLatLngList(siteList
          .map(
              (site) => LatLng(site.location.latitude, site.location.longitude))
          .toList());
      _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
            bounds, 50), // Padding of 50 to keep site at center
      );
    }
  }

  LatLngBounds _createBoundsFromLatLngList(List<LatLng> positions) {
    double southWestLat =
        positions.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    double southWestLng =
        positions.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    double northEastLat =
        positions.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    double northEastLng =
        positions.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 247, 250),
      body: SafeArea(
          child: Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 247, 250),
        endDrawer: Drawer(
          child: BlocBuilder<SiteBloc, SiteState>(
            builder: (context, state) {
              if (state is SiteListLoaded) {
                return ListView.builder(
                  itemCount: state.sites.length,
                  itemBuilder: (context, index) {
                    final site = state.sites[index];
                    return ListTile(
                      title: Text(site.name),
                      onTap: () {
                        Navigator.of(context).pop();
                        _mapController.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(site.location.latitude,
                                site.location.longitude),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is SiteLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Center(child: Text('Failed to load sites'));
              }
            },
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _sitePosition,
                zoom: 14.0,
              ),
              markers: _markers,
              circles: _circles,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _mapControllerCompleter.complete();
              },
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Builder(
                builder: (context) {
                  return FloatingActionButton(
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Icon(Icons.menu),
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
