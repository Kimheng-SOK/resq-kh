import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/top_app_bar.dart';
import 'widgets/header_banner.dart';
import 'widgets/step_card.dart';
import 'widgets/crucial_warning.dart';
import 'widgets/progress_footer.dart';

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class FirstAidStep {
  final int number;
  final String title;
  final String description;
  final String imageUrl;
  final String imageAlt;

  const FirstAidStep({
    required this.number,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.imageAlt,
  });
}

class FirstAidProtocol {
  final String title;
  final String description;
  final List<FirstAidStep> steps;
  final String? crucialWarning;

  const FirstAidProtocol({
    required this.title,
    required this.description,
    required this.steps,
    this.crucialWarning,
  });
}

// ---------------------------------------------------------------------------
// Protocols data — one entry per condition
// ---------------------------------------------------------------------------

const Map<String, FirstAidProtocol> firstAidProtocols = {
  'snake-bite': FirstAidProtocol(
    title: 'Snake Bite',
    description:
        'Follow these critical steps immediately\nwhile waiting for emergency responders.',
    crucialWarning:
        'Do NOT use a tourniquet or attempt to suck the venom out. '
        'These methods are ineffective and can cause more damage.',
    steps: [
      FirstAidStep(
        number: 1,
        title: 'Keep Calm',
        description:
            'Panic increases heart rate, which spreads venom faster through the body. '
            'Sit or lie down and minimize movement.',
        imageUrl: '',
        imageAlt:
            'Person sitting calmly to reduce heart rate after a snake bite',
      ),
      FirstAidStep(
        number: 2,
        title: 'Immobilize Limb',
        description:
            "Keep the bitten area (arm or leg) still and at or below the level "
            "of the heart to slow the venom's spread.",
        imageUrl: '',
        imageAlt:
            'Person holding their arm still to immobilize the bitten limb',
      ),
      FirstAidStep(
        number: 3,
        title: 'Remove Constraints',
        description:
            'Immediately remove rings, watches, or tight clothing near the bite '
            'site, as rapid swelling is likely to occur.',
        imageUrl: '',
        imageAlt: 'Hands removing a watch from the wrist near a bite site',
      ),
    ],
  ),

  'cardiac-arrest': FirstAidProtocol(
    title: 'Cardiac Arrest',
    description:
        'Act immediately — every second counts.\nBegin CPR until help arrives.',
    crucialWarning:
        'Do NOT leave the person alone. Keep performing CPR until emergency '
        'services arrive or an AED becomes available.',
    steps: [
      FirstAidStep(
        number: 1,
        title: 'Check Responsiveness',
        description:
            'Tap the person on the shoulders firmly and shout "Are you okay?"'
            'If there is no response, call 119 immediately.',
        imageUrl: '',
        imageAlt: 'Person checking responsiveness of an unconscious individual',
      ),
      FirstAidStep(
        number: 2,
        title: 'Call 119',
        description:
            'Call emergency services or ask a bystander to call 119 while you '
            'begin CPR. Put the phone on speaker.',
        imageUrl: '',
        imageAlt: 'Person calling emergency services on a mobile phone',
      ),
      FirstAidStep(
        number: 3,
        title: 'Start Chest Compressions',
        description:
            'Place the heel of your hand on the center of the chest. Push hard '
            'and fast — at least 5 cm deep, 100–120 times per minute.',
        imageUrl: '',
        imageAlt: 'Hands performing chest compressions on a person',
      ),
      FirstAidStep(
        number: 4,
        title: 'Give Rescue Breaths',
        description:
            'After 30 compressions, tilt the head back, lift the chin, and give '
            '2 rescue breaths. Each breath should last about 1 second.',
        imageUrl: '',
        imageAlt: 'Person giving rescue breaths to an unconscious individual',
      ),
      FirstAidStep(
        number: 5,
        title: 'Use AED if Available',
        description:
            'Turn on the AED, attach the pads as shown, and follow the voice '
            'instructions. Resume CPR immediately after the shock.',
        imageUrl: '',
        imageAlt: 'Person using an AED defibrillator device',
      ),
    ],
  ),

  'heavy-bleeding': FirstAidProtocol(
    title: 'Heavy Bleeding',
    description:
        'Apply pressure immediately to control blood loss\nwhile waiting for emergency help.',
    crucialWarning:
        'Do NOT remove an object embedded in a wound. Build padding around it '
        'instead. Removing it can cause more bleeding.',
    steps: [
      FirstAidStep(
        number: 1,
        title: 'Apply Direct Pressure',
        description:
            'Press firmly on the wound using a clean cloth or bandage. '
            'Maintain constant pressure — do not lift to check.',
        imageUrl: '',
        imageAlt: 'Hands applying firm pressure to a bleeding wound',
      ),
      FirstAidStep(
        number: 2,
        title: 'Elevate the Wound',
        description:
            'If possible, raise the injured area above the level of the heart '
            'to help slow blood flow to the wound.',
        imageUrl: '',
        imageAlt: 'Injured arm raised above heart level to reduce bleeding',
      ),
      FirstAidStep(
        number: 3,
        title: 'Secure the Bandage',
        description:
            'Once bleeding slows, secure the cloth with a bandage or tape. '
            'If blood soaks through, add more cloth on top — do not remove.',
        imageUrl: '',
        imageAlt: 'Bandage being secured firmly around a wound',
      ),
    ],
  ),

  'choking': FirstAidProtocol(
    title: 'Choking',
    description:
        'Act fast — a blocked airway can cause\nbrain damage within minutes.',
    crucialWarning:
        'Do NOT perform blind finger sweeps in the mouth. Only remove an object '
        'if you can clearly see it.',
    steps: [
      FirstAidStep(
        number: 1,
        title: 'Ask "Are You Choking?"',
        description:
            'If the person can cough forcefully, encourage them to keep coughing. '
            'Only intervene if they cannot cough, speak, or breathe.',
        imageUrl: '',
        imageAlt: 'Person asking a choking victim if they need help',
      ),
      FirstAidStep(
        number: 2,
        title: 'Give 5 Back Blows',
        description:
            'Lean the person forward and give 5 firm blows between the shoulder '
            'blades with the heel of your hand.',
        imageUrl: '',
        imageAlt: 'Person delivering back blows to a choking victim',
      ),
      FirstAidStep(
        number: 3,
        title: 'Give 5 Abdominal Thrusts',
        description:
            'Stand behind the person, make a fist above the navel, and thrust '
            'inward and upward sharply. Repeat up to 5 times.',
        imageUrl: '',
        imageAlt: 'Person performing abdominal thrusts on a choking victim',
      ),
    ],
  ),

  'unconscious': FirstAidProtocol(
    title: 'Unconscious',
    description:
        'Keep the person safe and monitor breathing\nuntil emergency help arrives.',
    crucialWarning:
        'Do NOT give food or water to an unconscious person. '
        'Do NOT leave them on their back if they are breathing — use recovery position.',
    steps: [
      FirstAidStep(
        number: 1,
        title: 'Check for Breathing',
        description:
            'Tilt the head back and lift the chin. Look, listen, and feel for '
            'breathing for no more than 10 seconds.',
        imageUrl: '',
        imageAlt: 'Person checking breathing of an unconscious individual',
      ),
      FirstAidStep(
        number: 2,
        title: 'Place in Recovery Position',
        description:
            'If the person is breathing, roll them onto their side. Bend the '
            'top knee forward to stabilize the position.',
        imageUrl: '',
        imageAlt: 'Person placed in recovery position on their side',
      ),
      FirstAidStep(
        number: 3,
        title: 'Call 119 and Monitor',
        description:
            'Call emergency services immediately. Stay with the person and '
            'monitor their breathing until help arrives.',
        imageUrl: '',
        imageAlt: 'Person monitoring an unconscious individual while on phone',
      ),
    ],
  ),
};

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class FirstAidDetailScreen extends StatefulWidget {
  /// The condition id — must match a key in [firstAidProtocols].
  /// e.g. 'cardiac-arrest', 'snake-bite', 'choking'
  final String conditionId;

  const FirstAidDetailScreen({super.key, required this.conditionId});

  @override
  State<FirstAidDetailScreen> createState() => _FirstAidDetailScreenState();
}

class _FirstAidDetailScreenState extends State<FirstAidDetailScreen> {
  int _currentStep = 1;
  late ScrollController _scrollController;
  final Map<int, GlobalKey> _stepKeys = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  FirstAidProtocol get _protocol =>
      firstAidProtocols[widget.conditionId] ??
      const FirstAidProtocol(
        title: 'Unknown',
        description: 'Protocol not found.',
        steps: [],
      );

  int get _totalSteps => _protocol.steps.length;

  void _handleBack() {
    setState(() => _currentStep = (_currentStep - 1).clamp(1, _totalSteps));
    _scrollToStep();
  }

  void _handleNext() {
    setState(() => _currentStep = (_currentStep + 1).clamp(1, _totalSteps));
    _scrollToStep();
  }

  void _scrollToStep() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _stepKeys[_currentStep];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          alignment: 0.2,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  ScrollContext? _findContextByKey(ValueKey<String> key) {
    try {
      return _scrollController.position.context;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final protocol = _protocol;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: TopAppBar(
        onBack: () => context.go('/first-aid'),
        onSettings: () {},
      ),
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderBanner(
                    title: protocol.title,
                    description: protocol.description,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: protocol.steps.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final step = entry.value;
                        final stepNumber = step.number;
                        _stepKeys.putIfAbsent(stepNumber, () => GlobalKey());
                        return StepCard(
                          key: _stepKeys[stepNumber],
                          number: step.number,
                          title: step.title,
                          description: step.description,
                          imageUrl: step.imageUrl,
                          imageAlt: step.imageAlt,
                          isLast: idx == protocol.steps.length - 1,
                        );
                      }).toList(),
                    ),
                  ),
                  if (protocol.crucialWarning != null)
                    CrucialWarning(message: protocol.crucialWarning!),
                ],
              ),
            ),
          ),

          // Sticky footer
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
