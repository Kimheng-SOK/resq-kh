import 'package:flutter/material.dart';

class StepCard extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final String imageUrl;
  final String imageAlt;
  final bool isLast;

  const StepCard({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.imageAlt,
    this.isLast = false,
  });

  // ← new method to handle both asset and network images
  Widget _buildImage() {
    if (imageUrl.isEmpty) return const SizedBox.shrink();

    final imageWidget = imageUrl.startsWith('images/')
        ? Image.asset(
            'assets/$imageUrl',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Color(0xFF5B403D),
              ),
            ),
          )
        : Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFAF101A),
                  strokeWidth: 2,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Color(0xFF5B403D),
              ),
            ),
          );

    return Semantics(
      label: imageAlt,
      image: true,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDE2E6), width: 1),
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 276 / 142,
          child: imageWidget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E9EB), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number circle
          Semantics(
            hidden: true,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFEF6E56),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 28 / 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    height: 20 / 16,
                  ),
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontSize: 18,
                    height: 28 / 18,
                  ),
                ),

                // Image — only shows if imageUrl is not empty
                if (imageUrl.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildImage(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}