import 'dart:convert';

import 'package:app/services/osm_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/core/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyPlacesScreen extends StatefulWidget {
  const NearbyPlacesScreen({super.key});

  @override
  State<NearbyPlacesScreen> createState() => _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState extends State<NearbyPlacesScreen> {
  final Distance _distance = const Distance();
  LatLng? userLocation;
  List<dynamic> places = [];
  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  double _distanceInKm(dynamic place) {
    if (userLocation == null) {
      return 0;
    }

    final meters = _distance(userLocation!, LatLng(place['lat'], place['lon']));

    return meters / 1000;
  }

  void _showPlaceDialog(dynamic place) {
    final tags = place['tags'] ?? {};

    final name = tags['name:en'] ?? tags['name'] ?? 'Unknown Place';

    final amenity = tags['amenity'] ?? 'Unknown';

    final phone = tags['phone'] ?? tags['contact:phone'];

    final distanceKm = _distanceInKm(place);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(amenity.toUpperCase()),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.navigation),
                  label: const Text('Navigate'),
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToPlace(place);
                  },
                ),
              ),

              const SizedBox(height: 15),

              if (phone != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.call),
                    label: Text('Call $phone'),
                    onPressed: () {
                      Navigator.pop(context);
                      _callPlace(phone);
                    },
                  ),
                ),

              const SizedBox(height: 15),

              Text('${distanceKm.toStringAsFixed(1)} km away'),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _callPlace(String phone) async {
    final uri = Uri.parse('tel:$phone');

    await launchUrl(uri);
  }

  Future<void> _navigateToPlace(dynamic place) async {
    final lat = place['lat'];
    final lon = place['lon'];

    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon',
    );

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _loadLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();

      if (position == null) {
        return;
      }

      final placesData = await OsmService.searchNearby(
        position.latitude,
        position.longitude,
      );

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);

        places = placesData;
      });

      debugPrint('PLACES FOUND: ${places.length}');

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint('Location Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(initialCenter: userLocation!, initialZoom: 15),
            children: [
              TileLayer(
                urlTemplate:
                    'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
              ),

              MarkerLayer(
                markers: [
                  // User location
                  Marker(
                    point: userLocation!,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),

                  // Location from OSM
                  ...places.map((place) {
                    final amenity = place['tags']?['amenity'];

                    IconData icon;
                    Color color;

                    switch (amenity) {
                      case 'hospital':
                        icon = Icons.local_hospital;
                        color = Colors.red;
                        break;

                      case 'police':
                        icon = Icons.local_police;
                        color = Colors.blue;
                        break;

                      case 'fire_station':
                        icon = Icons.local_fire_department;
                        color = Colors.orange;
                        break;

                      default:
                        icon = Icons.location_on;
                        color = Colors.grey;
                    }

                    return Marker(
                      point: LatLng(place['lat'], place['lon']),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          _showPlaceDialog(place);
                        },
                        child: Icon(icon, color: color, size: 35),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Nearby Places',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
