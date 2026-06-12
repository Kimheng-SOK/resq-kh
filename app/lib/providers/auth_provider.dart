import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/user_model.dart';
import 'package:app/services/api/auth_api_service.dart';
import 'package:app/services/auth_storage_service.dart';
import 'package:app/providers/user_provider.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> checkAuth() async {
    final token = await AuthStorageService.getToken();
    state = state.copyWith(isLoggedIn: token != null);
  }

  Future<bool> sendOtp({
    required String fullName,
    String? email,
    required String phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await AuthApiService.sendOtp(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Map<String, dynamic>?> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await AuthApiService.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );
      final token = result['data']?['access_token'] as String?;
      if (token != null) {
        await AuthStorageService.saveToken(token);

        // Seed the user provider with the user data from the OTP response
        final userData = result['data']?['user'] as Map<String, dynamic>?;
        if (userData != null) {
          final user = UserModel.fromJson(userData);
          await AuthStorageService.saveUserId(user.id);
          await ref.read(userProvider.notifier).setUserFromLogin(user);
        }
      }
      state = state.copyWith(isLoggedIn: true);
      return result;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    await AuthStorageService.clearAll();
    ref.read(userProvider.notifier).clearUser();
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
