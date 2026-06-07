import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  Future<void> _allowLocation(BuildContext context) async {
    // TODO:
    // Request location permission
    // Save user location to backend

    context.go('/complete-profile');
  }

  void _skip(BuildContext context) {
    context.go('/complete-profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: 120,
                color: Color(0xFFD32F2F),
              ),

              const SizedBox(height: 32),

              const Text(
                'Enable Location',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              const Text(
                'RESQ uses your location to quickly connect you with nearby emergency services and provide faster assistance during emergencies.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: () => _allowLocation(context),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text(
                    'Allow Location',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => _skip(context),

                child: const Text(
                  'Skip for now',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
