import 'package:app/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/theme/locale_controller.dart';
import 'core/l10n/app_localizations.dart';

class ResQApp extends StatelessWidget {
  final String initialRoute;

  const ResQApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(initialRoute);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController()..loadThemeMode(),
        ),
        ChangeNotifierProvider<LocaleController>(
          create: (_) => LocaleController()..loadLocale(),
        ),
      ],
      child: Consumer2<ThemeController, LocaleController>(
        builder: (context, themeController, localeController, _) {
          return MaterialApp.router(
            title: 'ResQ App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            locale: localeController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
