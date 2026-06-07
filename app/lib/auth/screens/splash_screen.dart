import 'package:app/services/api/auth_api_service.dart';
import 'package:app/services/auth_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Splash screen that decides where to route the user on app start.
///
/// Flow:
/// - No token → Register (fresh start)
/// - Token exists → validate with backend
///   - Invalid → Clear cache → Register
///   - Valid → check cached profile
///     - Incomplete → CompleteProfile (fresh user who skipped)
///     - Complete → Home
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final token = await AuthStorageService.getToken();

    if (token == null) {
      // No token — fresh install or user deleted their account
      if (mounted) context.go('/register');
      return;
    }

    // Token exists — validate it against the backend
    final isValid = await AuthApiService.validateToken(token);

    if (!mounted) return;

    if (isValid) {
      // Token is valid — check if the user still needs to complete their profile
      final cachedUser = await AuthStorageService.getCachedUser();
      if (cachedUser != null && !cachedUser.isProfileComplete) {
        // Profile incomplete — send them back to complete it
        if (mounted) context.go('/complete-profile');
      } else {
        // Everything is good — go to home
        if (mounted) context.go('/');
      }
    } else {
      // Token is invalid (expired, or account deleted from backend)
      // Clear everything so the user can start fresh
      await AuthStorageService.clearAll();
      if (mounted) context.go('/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFD32F2F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.health_and_safety, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'RESQ',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Emergency Response System',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
