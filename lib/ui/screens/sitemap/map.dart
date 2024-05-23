import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('locations');
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  late LatLng _initialPosition;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initialPosition = LatLng(45.427675000001365, -108.40590330000137);
    _signInAndFetchLocation();
  }

  Future<void> _signInAndFetchLocation() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: 'client@gmail.com',
        password: '123456',
      );
      print("----------auth on firebase----------");
      if (userCredential.user != null) {
        _fetchLocation();
      }
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }

  void _fetchLocation() {
    _databaseReference.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.exists) {
        var data = snapshot.value as Map;
        data.forEach((key, value) {
          var email = value['email'];
          var latitude = value['latitude'];
          var longitude = value['longitude'];

          if (email == 'john.tester@gmail.com') {
            setState(() {
              _markers.add(
                Marker(
                  markerId: MarkerId(email),
                  position: LatLng(latitude, longitude),
                  infoWindow: InfoWindow(title: email),
                ),
              );
              _initialPosition = LatLng(latitude, longitude);
              _mapController.animateCamera(
                CameraUpdate.newLatLng(_initialPosition),
              );
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
