import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color.dart';
import '../../core/data/first_aid_data.dart';

class FirstAidListScreen extends StatelessWidget {
  const FirstAidListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimColor = theme.textTheme.bodyMedium!.color!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('First Aid Tips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learn life-saving first aid techniques.\nStep-by-step guides for emergencies.',
              style: TextStyle(color: dimColor, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: firstAidTips.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final tip = firstAidTips[index];
                  return _FirstAidCard(
                    icon: tip.icon,
                    title: tip.title,
                    description: tip.description,
                    onTap: () => context.push('/first-aid/${tip.id}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FirstAidCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _FirstAidCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final dimColor = theme.textTheme.bodyMedium!.color!;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(description,
                        style: TextStyle(
                            color: dimColor, fontSize: 13, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: AppColors.red, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
