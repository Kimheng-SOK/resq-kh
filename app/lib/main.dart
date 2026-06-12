import 'package:app/services/auth_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  final token = await AuthStorageService.getToken();

  final initialRoute = token != null ? '/' : '/splash';

  runApp(ProviderScope(child: ResQApp(initialRoute: initialRoute)));
}
