import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/home/home_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/services/service_list_screen.dart';
import '../../features/services/service_detail_screen.dart';
import '../../features/contacts/contacts_screen.dart';
import '../../features/contacts/contact_form_screen.dart';
import '../../features/first_aid/first_aid_list_screen.dart';
import '../../features/first_aid/first_aid_detail_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../widgets/bottomNav.dart';
import '../../widgets/headerNav.dart';
import '../theme/app_color.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(
          currentLocation: state.matchedLocation,
          child: child,
        );
      },
      routes: [
        // Home
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),

        // Map
        GoRoute(path: '/map', builder: (context, state) => const MapScreen()),

        // SOS
        GoRoute(
          path: '/sos',
          builder: (context, state) => const _SosScreen(),
        ),

        // Contacts list
        GoRoute(
          path: '/contacts',
          builder: (context, state) => const ContactsScreen(),
        ),

        // First Aid list
        GoRoute(
          path: '/first-aid',
          builder: (context, state) => const FirstAidListScreen(),
        ),
      ],
    ),

    // Full-screen routes (no bottom nav)
    GoRoute(
      path: '/services/:type',
      builder: (context, state) => ServiceListScreen(
        serviceType: state.pathParameters['type']!,
      ),
    ),
    GoRoute(
      path: '/service/:id',
      builder: (context, state) => ServiceDetailScreen(
        serviceId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/first-aid/:tipId',
      builder: (context, state) => FirstAidDetailScreen(
        tipId: state.pathParameters['tipId']!,
      ),
    ),
    GoRoute(
      path: '/contacts/add',
      builder: (context, state) => const ContactFormScreen(),
    ),
    GoRoute(
      path: '/contacts/edit/:contactId',
      builder: (context, state) => ContactFormScreen(
        contactId: state.pathParameters['contactId'],
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Notifications'),
    ),
  ],
);

class AppShell extends StatelessWidget {
  final String currentLocation;
  final Widget child;

  const AppShell({super.key, required this.currentLocation, required this.child});

  int _currentIndexForLocation(String location) {
    switch (location) {
      case '/map':
        return 1;
      case '/sos':
        return 2;
      case '/contacts':
        return 3;
      case '/first-aid':
        return 4;
      default:
        return 0;
    }
  }

  String _locationForIndex(int index) {
    switch (index) {
      case 1:
        return '/map';
      case 2:
        return '/sos';
      case 3:
        return '/contacts';
      case 4:
        return '/first-aid';
      default:
        return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          HeaderNavBar(
            userName: 'RESQ',
            hasNotification: true,
            onNotificationTap: () => context.push('/notifications'),
            onProfileTap: () => context.push('/profile'),
          ),
          Expanded(child: child),
          BottomNavBar(
            currentIndex: _currentIndexForLocation(currentLocation),
            onTap: (index) => context.go(_locationForIndex(index)),
          ),
        ],
      ),
    );
  }
}

// --- Placeholder / Simple screens ---

class _SosScreen extends StatelessWidget {
  const _SosScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Emergency'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone_in_talk_rounded,
              size: 80,
              color: AppColors.red,
            ),
            const SizedBox(height: 24),
            Text(
              'Calling Emergency Services',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              '119',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 48,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'National Emergency Hotline',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('tel:119');
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
                icon: const Icon(Icons.call_rounded),
                label: const Text(
                  'CALL NOW',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/'),
              child: Text(
                'Cancel',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 64,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Coming soon',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
