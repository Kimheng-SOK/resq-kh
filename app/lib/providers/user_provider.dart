import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/user_model.dart';
import 'package:app/services/api/user_api_service.dart';
import 'package:app/services/auth_storage_service.dart';

/// Immutable state for user profile and account actions.
class UserState {
  final bool isLoading;
  final String? error;
  final UserModel? user;
  /// Set to `true` when the server returns 401 — token is dead,
  /// the UI should redirect the user to the register screen.
  final bool needsReAuth;

  const UserState({
    this.isLoading = false,
    this.error,
    this.user,
    this.needsReAuth = false,
  });

  UserState copyWith({
    bool? isLoading,
    String? error,
    UserModel? user,
    bool clearError = false,
    bool? needsReAuth,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      user: user ?? this.user,
      needsReAuth: needsReAuth ?? this.needsReAuth,
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() => const UserState();

  /// Fetch the user profile from the API and cache it locally.
  /// Falls back to the locally cached user when offline.
  Future<UserModel?> fetchProfile() async {
    final token = await AuthStorageService.getToken();
    if (token == null) {
      // Load cached user for offline display
      final cached = await AuthStorageService.getCachedUser();
      if (cached != null) {
        state = state.copyWith(user: cached);
      } else {
        state = state.copyWith(error: 'Not authenticated');
      }
      return cached;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final profile = await UserApiService.fetchUserProfile(token);
      // Cache for offline use
      await AuthStorageService.saveUser(profile);
      await AuthStorageService.saveUserId(profile.id);
      state = state.copyWith(user: profile);
      return profile;
    } catch (e) {
      final errorMsg = e.toString();

      // Token is invalid (401) — account was deleted or token expired.
      // Clear everything and signal the UI to redirect to register.
      if (errorMsg.contains('401')) {
        await AuthStorageService.clearAll();
        state = state.copyWith(
          error: 'Session expired. Please register again.',
          needsReAuth: true,
        );
        return null;
      }

      // On network error, fall back to cached user
      final cached = await AuthStorageService.getCachedUser();
      if (cached != null) {
        state = state.copyWith(user: cached, clearError: true);
        return cached;
      }
      state = state.copyWith(error: errorMsg);
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Populate user state from a login/OTP response (no API call needed).
  /// Saves the user to local cache immediately.
  Future<void> setUserFromLogin(UserModel user) async {
    await AuthStorageService.saveUser(user);
    state = state.copyWith(user: user, clearError: true);
  }

  /// Clear the user state (called on logout without deleting account).
  void clearUser() {
    state = const UserState();
  }

  /// Update the user's medical/profile info and refresh local state + cache.
  Future<UserModel?> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? bloodGroup,
    String? allergies,
    String? medicalConditions,
    String? preferredLanguage,
    bool? darkModeEnabled,
  }) async {
    final token = await AuthStorageService.getToken();
    if (token == null) {
      state = state.copyWith(error: 'Not authenticated');
      return null;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final updated = await UserApiService.updateProfile(
        token: token,
        fullName: fullName,
        phoneNumber: phoneNumber,
        bloodGroup: bloodGroup,
        allergies: allergies,
        medicalConditions: medicalConditions,
        preferredLanguage: preferredLanguage,
        darkModeEnabled: darkModeEnabled,
      );
      await AuthStorageService.saveUser(updated);
      state = state.copyWith(user: updated);
      return updated;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> deleteAccount() async {
    final token = await AuthStorageService.getToken();
    if (token == null) {
      state = state.copyWith(error: 'Not authenticated');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await UserApiService.deleteAccount(token);
      // Clear all auth data (token + cached user)
      await AuthStorageService.clearAll();
      state = const UserState();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);
