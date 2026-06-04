import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api/auth_api_service.dart';
import 'package:app/services/auth_storage_service.dart';

/// Immutable state for the auth flow.
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
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // pass null to clear
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

/// Manages authentication state: OTP flow, token persistence, login state.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// Check whether a stored token exists (app startup).
  Future<void> checkAuth() async {
    final token = await AuthStorageService.getToken();
    state = state.copyWith(isLoggedIn: token != null);
  }

  /// Step 1 — send OTP. Returns true on success.
  Future<bool> sendOtp({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
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

  /// Step 2 — verify OTP. Returns the response data on success, null on failure.
  Future<Map<String, dynamic>?> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await AuthApiService.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );
      final token = result['data']?['access_token'] as String?;
      if (token != null) {
        await AuthStorageService.saveToken(token);
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

  /// Log out — clear token and reset state.
  Future<void> logout() async {
    await AuthStorageService.clearToken();
    state = const AuthState();
  }
}

/// Riverpod provider for auth state.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
