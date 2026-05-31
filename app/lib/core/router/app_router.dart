import 'package:app/features/contacts/ambulance_screen.dart';
import 'package:app/features/contacts/contact_screen.dart';
import 'package:app/features/contacts/fire_station_screen.dart';
import 'package:app/features/contacts/general_contacts_screen.dart';
import 'package:app/features/contacts/police_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../widgets/bottomNav.dart';
import '../../widgets/headerNav.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(currentLocation: state.matchedLocation, child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/map',
          builder: (context, state) => const _RouteBody(title: 'Map'),
        ),
        GoRoute(
          path: '/sos',
          builder: (context, state) => const _RouteBody(title: 'SOS'),
        ),
        GoRoute(
          path: '/contacts',
          builder: (context, state) => const ContactsScreen(),
          routes: [
            GoRoute(
              path: '/general',
              builder: (context, state) => const GeneralContactsScreen(),
            ),
            GoRoute(
              path: '/police',
              builder: (context, state) => const PoliceScreen(),
            ),
            GoRoute(
              path: '/ambulance',
              builder: (context, state) => const AmbulanceScreen(),
            ),
            GoRoute(
              path: '/fire',
              builder: (context, state) => const FireStationScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/first-aid',
          builder: (context, state) => const _RouteBody(title: 'First Aid'),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const _RouteBody(title: 'Profile'),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const _RouteBody(title: 'Notifications'),
        ),
      ],
    ),
  ],
);

class AppShell extends StatelessWidget {
  final String currentLocation;
  final Widget child;

  const AppShell({Key? key, required this.currentLocation, required this.child})
    : super(key: key);

  int _currentIndexForLocation(String location) {
    if (location.startsWith('/contacts')) return 3;
    if (location.startsWith('/map')) return 1;
    if (location.startsWith('/sos')) return 2;
    if (location.startsWith('/first-aid')) return 4;

    return 0;
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
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          HeaderNavBar(
            userName: 'RESQ',
            hasNotification: true,
            onNotificationTap: () => context.go('/notifications'),
            onProfileTap: () => context.go('/profile'),
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

class _RouteBody extends StatelessWidget {
  final String title;

  const _RouteBody({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
