import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/incident_type_model.dart';
import 'package:app/services/api/incident_type_api_service.dart';

class IncidentTypeState {
  final bool isLoading;
  final String? error;
  final List<IncidentType> types;

  const IncidentTypeState({
    this.isLoading = false,
    this.error,
    this.types = const [],
  });

  IncidentTypeState copyWith({
    bool? isLoading,
    String? error,
    List<IncidentType>? types,
    bool clearError = false,
  }) {
    return IncidentTypeState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      types: types ?? this.types,
    );
  }
}

class IncidentTypeNotifier extends Notifier<IncidentTypeState> {
  @override
  IncidentTypeState build() => const IncidentTypeState();

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final types = await IncidentTypeService.fetchAll();
      state = state.copyWith(types: types);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final incidentTypeProvider =
    NotifierProvider<IncidentTypeNotifier, IncidentTypeState>(
  IncidentTypeNotifier.new,
);