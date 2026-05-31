import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme_controller.dart';

class ResQApp extends StatelessWidget {
  const ResQApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeController>(
      create: (_) => ThemeController()..loadThemeMode(),
      child: MaterialApp.router(
        title: 'ResQ App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF2F2F2),
          fontFamily: 'SF Pro Display',
        ),
        routerConfig: router,
      ),
    );
  }
}
