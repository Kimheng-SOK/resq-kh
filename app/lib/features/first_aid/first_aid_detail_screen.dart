import 'package:app/core/l10n/app_localizations.dart';
import 'package:app/providers/first_aid_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/top_app_bar.dart';
import 'widgets/header_banner.dart';
import 'widgets/step_card.dart';
import 'widgets/progress_footer.dart';

class FirstAidDetailScreen extends ConsumerStatefulWidget {
  final String conditionId;
  const FirstAidDetailScreen({super.key, required this.conditionId});

  @override
  ConsumerState<FirstAidDetailScreen> createState() =>
      _FirstAidDetailScreenState();
}

class _FirstAidDetailScreenState extends ConsumerState<FirstAidDetailScreen> {
  int _currentStep = 1;
  int _totalSteps = 0;                          
  final Map<int, GlobalKey> _stepKeys = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(firstAidProvider.notifier)
        .loadTopicBySlug(widget.conditionId));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleNext() {
    setState(() => _currentStep = (_currentStep + 1).clamp(1, _totalSteps));
    _scrollToStep(_currentStep);
  }

  void _handleBack() {
    setState(() => _currentStep = (_currentStep - 1).clamp(1, _totalSteps));
    _scrollToStep(_currentStep);
  }

  void _scrollToStep(int step) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _stepKeys[step];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          alignment: 0.1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(firstAidProvider);
    final topic = state.selectedTopic;

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFAF101A)),
        ),
      );
    }

    if (state.error != null || topic == null) {
      return Scaffold(
        body: Center(
          child: Text(l10n.failedToLoadConditions(state.error?.toString() ?? l10n.topicNotFound)),
        ),
      );
    }

    _totalSteps = topic.steps.length;

    final translation = topic.translations.isNotEmpty
        ? topic.translations.first
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: TopAppBar(
        onBack: () => context.go('/first-aid'),
        onSettings: () {},
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderBanner(
                    title: translation?.title ?? topic.slug,
                    description: translation?.summary ?? '',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: topic.steps.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final step = entry.value;
                        final stepTranslation = step.translations.isNotEmpty
                            ? step.translations.first
                            : null;

                      
                        _stepKeys.putIfAbsent(
                            step.stepNumber, () => GlobalKey());

                        return StepCard(
                          key: _stepKeys[step.stepNumber], // ← attach key
                          number: step.stepNumber,
                          title: l10n.stepN(step.stepNumber),
                          description: stepTranslation?.instruction ?? '',
                          imageUrl: step.imageUrl ?? '',
                          imageAlt: stepTranslation?.instruction ?? '',
                          isLast: idx == topic.steps.length - 1,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_totalSteps > 0)
            ProgressFooter(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onBack: _handleBack,      
              onNext: _handleNext,
              canGoBack: _currentStep > 1,
              canGoNext: _currentStep < _totalSteps,
            ),
        ],
      ),
    );
  }
}