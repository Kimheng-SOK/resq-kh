/// Step within a first-aid procedure
class FirstAidStep {
  final int stepNumber;
  final String instruction;
  final String? imageAsset; // placeholder for future images

  const FirstAidStep({
    required this.stepNumber,
    required this.instruction,
    this.imageAsset,
  });
}

/// A first-aid topic with step-by-step instructions
class FirstAidTip {
  final String id;
  final String title;
  final String icon; // emoji icon for quick visual identification
  final String description;
  final List<FirstAidStep> steps;
  final List<String> warnings; // important safety warnings

  const FirstAidTip({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
    this.steps = const [],
    this.warnings = const [],
  });
}
