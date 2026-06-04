import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api/user_api_service.dart';
import 'package:app/services/auth_storage_service.dart';

/// Immutable state for user profile and account actions.
class UserState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? profile;

  const UserState({
    this.isLoading = false,
    this.error,
    this.profile,
  });

  UserState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? profile,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      profile: profile ?? this.profile,
    );
  }
}

/// Manages user profile fetching and account deletion.
class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() => const UserState();

  /// Fetch the authenticated user's profile.
  Future<Map<String, dynamic>?> fetchProfile() async {
    final token = await AuthStorageService.getToken();
    if (token == null) {
      state = state.copyWith(error: 'Not authenticated');
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await UserApiService.fetchUserProfile(token);
      state = state.copyWith(profile: profile);
      return profile;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Delete the authenticated user's account.
  /// Returns true on success, false on failure.
  Future<bool> deleteAccount() async {
    final token = await AuthStorageService.getToken();
    if (token == null) {
      state = state.copyWith(error: 'Not authenticated');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      await UserApiService.deleteAccount(token);
      await AuthStorageService.clearToken();
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

/// Riverpod provider for user state.
final userProvider = NotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);
