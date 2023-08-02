// nature_walk_planner_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class NatureWalkPlannerScreen extends StatefulWidget {
  @override
  _NatureWalkPlannerScreenState createState() => _NatureWalkPlannerScreenState();
}

class _NatureWalkPlannerScreenState extends State<NatureWalkPlannerScreen> {
  // Replace these sample data with actual data from your app or backend
  List<NatureSpot> _natureSpots = [
    NatureSpot(
      name: 'Nature Park 1',
      latitude: 37.7749,
      longitude: -122.4194,
      description: 'A beautiful nature park with hiking trails.',
    ),
    NatureSpot(
      name: 'Nature Park 2',
      latitude: 37.7859,
      longitude: -122.3969,
      description: 'A serene nature park with a lake and picnic spots.',
    ),
    // Add more nature spots as needed
  ];

  GoogleMapController? _mapController;
  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    // Set up markers for each nature spot on the map
    _natureSpots.forEach((spot) {
      _markers.add(
        Marker(
          markerId: MarkerId(spot.name),
          position: LatLng(spot.latitude, spot.longitude),
          infoWindow: InfoWindow(
            title: spot.name,
            snippet: spot.description,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Replace this with the JSON representation of your custom map style
    final String customMapStyle = '''
      [
        {
          "featureType": "poi.park",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#00ff00"
            }
          ]
        }
        // Add more styling rules for other green areas as needed
      ]
    ''';

    return Scaffold(
      appBar: AppBar(
        title: Text('Nature Walk Planner'),
      ),
      body: GoogleMap(
        mapType: MapType.normal, // Set the map type to custom
        initialCameraPosition: CameraPosition(
          target: LatLng(_natureSpots[0].latitude, _natureSpots[0].longitude),
          zoom: 13,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _mapController!.setMapStyle(customMapStyle); // Apply the custom map style
        },
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement any action when the user taps the floating action button
        },
        child: Icon(Icons.location_on),
      ),
    );
  }
}

class NatureSpot {
  final String name;
  final double latitude;
  final double longitude;
  final String description;

  NatureSpot({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
  });
}
