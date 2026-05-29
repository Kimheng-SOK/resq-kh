import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color.dart';
import '../../core/data/first_aid_data.dart';
import '../../core/models/first_aid_tip.dart';

class FirstAidDetailScreen extends StatelessWidget {
  final String tipId;

  const FirstAidDetailScreen({super.key, required this.tipId});

  @override
  Widget build(BuildContext context) {
    final tip = getFirstAidTipById(tipId);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final dimColor = theme.textTheme.bodyMedium!.color!;

    if (tip == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text('Tip not found',
              style: TextStyle(fontSize: 16, color: dimColor)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tip.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(tip.icon, style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 12),
                    Text(tip.title,
                        style: TextStyle(
                            color: onSurface,
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(tip.description,
                        style: TextStyle(
                            color: dimColor, fontSize: 14, height: 1.5),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Step-by-Step Instructions',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ...tip.steps.map((step) => _StepCard(step: step, onSurface: onSurface)),
            if (tip.warnings.isNotEmpty) ...[
              const SizedBox(height: 24),
              Card(
                color: AppColors.red.withValues(alpha: 0.06),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: AppColors.red, size: 24),
                          SizedBox(width: 8),
                          Text('Important Warnings',
                              style: TextStyle(
                                  color: AppColors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...tip.warnings.map((w) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('⚠️',
                                    style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(w,
                                      style: TextStyle(
                                          color: onSurface,
                                          fontSize: 13,
                                          height: 1.4)),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final FirstAidStep step;
  final Color onSurface;

  const _StepCard({required this.step, required this.onSurface});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('${step.stepNumber}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(step.instruction,
                  style: TextStyle(
                      color: onSurface, fontSize: 15, height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
