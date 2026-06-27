import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/first_aid_topic.dart';
import 'package:app/services/api/first_aid_api_service.dart';

// --- State ---

class FirstAidState {
  final bool isLoading;
  final String? error;
  final List<FirstAidTopic> topics;
  final FirstAidTopic? selectedTopic;

  const FirstAidState({
    this.isLoading = false,
    this.error,
    this.topics = const [],
    this.selectedTopic,
  });

  FirstAidState copyWith({
    bool? isLoading,
    String? error,
    List<FirstAidTopic>? topics,
    FirstAidTopic? selectedTopic,
    bool clearError = false,
    bool clearSelectedTopic = false,
  }) {
    return FirstAidState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      topics: topics ?? this.topics,
      selectedTopic: clearSelectedTopic
          ? null
          : (selectedTopic ?? this.selectedTopic),
    );
  }
}

// --- Notifier ---

class FirstAidNotifier extends Notifier<FirstAidState> {
  @override
  FirstAidState build() => const FirstAidState();

  Future<void> loadTopics({String lang = 'en'}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final topics = await FirstAidApiService.fetchTopics(lang: lang);
      state = state.copyWith(topics: topics);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadTopicBySlug(String slug, {String lang = 'en'}) async {
    state = state.copyWith(isLoading: true, clearError: true,
        clearSelectedTopic: true);
    try {
      final topic = await FirstAidApiService.fetchTopicBySlug(slug, lang: lang);
      state = state.copyWith(selectedTopic: topic);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// --- Provider ---

final firstAidProvider = NotifierProvider<FirstAidNotifier, FirstAidState>(
  FirstAidNotifier.new,
);