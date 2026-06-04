import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Consumer;
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

class ResQApp extends StatelessWidget {
  const ResQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ChangeNotifierProvider<ThemeController>(
        create: (_) => ThemeController()..loadThemeMode(),
        child: Consumer<ThemeController>(
          builder: (context, themeController, _) {
            return MaterialApp.router(
              title: 'ResQ App',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeController.themeMode,
              routerConfig: router,
            );
          },
        ),
      ),
    );
  }
}
