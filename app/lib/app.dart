import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

class ResQApp extends StatelessWidget {
  const ResQApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ResQ App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F2F2),
        fontFamily: 'SF Pro Display', // Falls back to system font
      ),
      routerConfig: router,
    );
  }
}
