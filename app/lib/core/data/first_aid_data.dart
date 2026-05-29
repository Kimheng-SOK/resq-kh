import '../models/first_aid_tip.dart';

const List<FirstAidTip> firstAidTips = [
  FirstAidTip(
    id: 'cpr',
    title: 'CPR',
    icon: '❤️',
    description:
        'Cardiopulmonary Resuscitation (CPR) can save a life when someone\'s heart stops beating. Act fast — every second counts.',
    steps: [
      FirstAidStep(
        stepNumber: 1,
        instruction:
            'CHECK the scene for safety. Tap the person and shout "Are you OK?" to check responsiveness.',
      ),
      FirstAidStep(
        stepNumber: 2,
        instruction:
            'CALL 119 (ambulance) immediately or have someone else call while you start CPR.',
      ),
      FirstAidStep(
        stepNumber: 3,
        instruction:
            'PLACE the person on their back on a firm, flat surface. Kneel beside their chest.',
      ),
      FirstAidStep(
        stepNumber: 4,
        instruction:
            'CHEST COMPRESSIONS: Place the heel of one hand on the center of the chest (between the nipples). Place your other hand on top and interlock fingers.',
      ),
      FirstAidStep(
        stepNumber: 5,
        instruction:
            'PUSH hard and fast — at least 5 cm (2 inches) deep, at a rate of 100-120 compressions per minute. Let the chest rise completely between compressions.',
      ),
      FirstAidStep(
        stepNumber: 6,
        instruction:
            'If trained, give 2 rescue breaths after every 30 compressions. Tilt head back, lift chin, pinch nose, and blow until chest rises.',
      ),
      FirstAidStep(
        stepNumber: 7,
        instruction:
            'CONTINUE until help arrives, an AED is available, or the person shows signs of life. Do not stop unless you are exhausted.',
      ),
    ],
    warnings: [
      'Do NOT perform CPR on a person who is breathing normally.',
      'If unsure whether someone needs CPR, start compressions — it is better to try than do nothing.',
      'For infants, use only two fingers for compressions.',
      'Minimize interruptions to chest compressions.',
    ],
  ),
  FirstAidTip(
    id: 'burns',
    title: 'Burns',
    icon: '🔥',
    description:
        'Burns can be caused by heat, chemicals, electricity, or radiation. Quick and proper first aid reduces damage and pain.',
    steps: [
      FirstAidStep(
        stepNumber: 1,
        instruction:
            'REMOVE the person from the source of the burn. Extinguish flames with water or by smothering with a blanket.',
      ),
      FirstAidStep(
        stepNumber: 2,
        instruction:
            'COOL the burn under cool (not cold) running water for at least 10-20 minutes. Do NOT use ice — it can cause more tissue damage.',
      ),
      FirstAidStep(
        stepNumber: 3,
        instruction:
            'REMOVE any jewelry, belts, or tight clothing near the burned area before swelling starts. Do NOT remove clothing stuck to the burn.',
      ),
      FirstAidStep(
        stepNumber: 4,
        instruction:
            'COVER the burn loosely with a clean, dry cloth or sterile bandage. Do NOT apply butter, oil, egg white, or toothpaste.',
      ),
      FirstAidStep(
        stepNumber: 5,
        instruction:
            'For chemical burns: flush the area with cool running water for at least 20 minutes. Remove contaminated clothing while flushing.',
      ),
      FirstAidStep(
        stepNumber: 6,
        instruction:
            'SEEK emergency medical help if: burn is larger than your palm, on face/hands/feet/genitals, deep (third-degree), or caused by chemicals/electricity.',
      ),
    ],
    warnings: [
      'Do NOT apply ice directly to burns.',
      'Do NOT break blisters — they protect against infection.',
      'Do NOT apply adhesive bandages directly on burns.',
      'Electrical burns may look small on the surface but can cause deep internal damage — always seek medical help.',
    ],
  ),
  FirstAidTip(
    id: 'bleeding',
    title: 'Bleeding',
    icon: '🩸',
    description:
        'Severe bleeding can lead to shock and death within minutes. Apply firm, direct pressure immediately.',
    steps: [
      FirstAidStep(
        stepNumber: 1,
        instruction:
            'ENSURE your own safety first — wear gloves if available. Have the injured person lie down if possible.',
      ),
      FirstAidStep(
        stepNumber: 2,
        instruction:
            'EXPOSE the wound by removing or cutting away clothing. Look for the source of bleeding.',
      ),
      FirstAidStep(
        stepNumber: 3,
        instruction:
            'APPLY firm, direct pressure on the wound using a clean cloth, bandage, or your hand. Maintain continuous pressure — do NOT lift to check.',
      ),
      FirstAidStep(
        stepNumber: 4,
        instruction:
            'If blood soaks through, add MORE cloth on top — do NOT remove the original dressing as it disrupts clotting.',
      ),
      FirstAidStep(
        stepNumber: 5,
        instruction:
            'ELEVATE the injured area above the heart level if no fracture is suspected.',
      ),
      FirstAidStep(
        stepNumber: 6,
        instruction:
            'For severe bleeding on a limb and if trained: apply a tourniquet 5-8 cm above the wound, between the wound and heart. Note the time applied.',
      ),
      FirstAidStep(
        stepNumber: 7,
        instruction:
            'CALL 119 or get emergency help immediately. Watch for signs of shock — pale skin, rapid breathing, weakness, confusion.',
      ),
    ],
    warnings: [
      'Do NOT remove embedded objects from the wound — apply pressure around the object and bandage it in place.',
      'Do NOT wash a severe wound — focus on stopping the bleeding first.',
      'A tourniquet should only be used as a last resort for life-threatening bleeding.',
      'If the person shows signs of shock, cover them with a blanket and do not give food or drink.',
    ],
  ),
  FirstAidTip(
    id: 'snake-bite',
    title: 'Snake Bite',
    icon: '🐍',
    description:
        'Snake bites can be venomous and life-threatening. Stay calm and seek medical help immediately — do not attempt traditional remedies.',
    steps: [
      FirstAidStep(
        stepNumber: 1,
        instruction:
            'MOVE the person away from the snake. Do NOT try to catch or kill the snake — note its appearance (color, head shape, size) for identification.',
      ),
      FirstAidStep(
        stepNumber: 2,
        instruction:
            'KEEP the person CALM and still. Movement increases venom spread through the body. Have them lie down with the bite below heart level.',
      ),
      FirstAidStep(
        stepNumber: 3,
        instruction:
            'REMOVE any jewelry, watches, or tight clothing near the bite area before swelling begins.',
      ),
      FirstAidStep(
        stepNumber: 4,
        instruction:
            'APPLY a pressure immobilization bandage: wrap a bandage firmly over the bite site and up the entire limb (like wrapping a sprained ankle). It should be snug but you should be able to slip one finger under it.',
      ),
      FirstAidStep(
        stepNumber: 5,
        instruction:
            'SPLINT the limb to prevent movement. Keep the person as still as possible.',
      ),
      FirstAidStep(
        stepNumber: 6,
        instruction:
            'CALL 119 or transport the person to the nearest hospital immediately. Antivenom is the only effective treatment.',
      ),
    ],
    warnings: [
      'Do NOT suck the venom out with your mouth.',
      'Do NOT cut the wound or apply a tourniquet.',
      'Do NOT apply ice, electric shock, or traditional herbs.',
      'Do NOT give the person alcohol, caffeine, or medication unless prescribed by a doctor.',
      'Do NOT waste time trying to catch the snake — focus on getting to a hospital.',
    ],
  ),
  FirstAidTip(
    id: 'choking',
    title: 'Choking',
    icon: '😮',
    description:
        'Choking occurs when an object blocks the airway. A person who cannot cough, speak, or breathe needs immediate help.',
    steps: [
      FirstAidStep(
        stepNumber: 1,
        instruction:
            'ASK the person: "Are you choking?" If they can cough forcefully, encourage them to keep coughing. If they cannot cough, speak, or breathe, act immediately.',
      ),
      FirstAidStep(
        stepNumber: 2,
        instruction:
            'CALL 119 or have someone call while you perform the Heimlich maneuver.',
      ),
      FirstAidStep(
        stepNumber: 3,
        instruction:
            'HEIMLICH MANEUVER: Stand behind the person. Wrap your arms around their waist. Make a fist with one hand, thumb side inward, and place it just above their navel.',
      ),
      FirstAidStep(
        stepNumber: 4,
        instruction:
            'GRASP your fist with your other hand. Give quick, upward thrusts — like trying to lift the person. Each thrust should be a separate, distinct movement.',
      ),
      FirstAidStep(
        stepNumber: 5,
        instruction:
            'REPEAT thrusts until the object is expelled or the person becomes unconscious. If they become unconscious, lower them to the ground and start CPR.',
      ),
      FirstAidStep(
        stepNumber: 6,
        instruction:
            'FOR PREGNANT WOMEN or obese persons: place your hands higher — at the base of the breastbone (same position as chest compressions) instead of the abdomen.',
      ),
      FirstAidStep(
        stepNumber: 7,
        instruction:
            'FOR INFANTS (under 1 year): Give 5 back blows (between shoulder blades with heel of hand) followed by 5 chest thrusts (two fingers on breastbone). Repeat.',
      ),
    ],
    warnings: [
      'Do NOT perform the Heimlich maneuver on someone who can cough or speak — encourage coughing instead.',
      'Do NOT try to blindly sweep the mouth with your finger — you may push the object deeper.',
      'For an infant, never perform abdominal thrusts — use back blows and chest thrusts only.',
      'Even if the object is expelled, the person should be checked by a doctor — internal injuries can occur.',
    ],
  ),
];

/// Get a first-aid tip by ID
FirstAidTip? getFirstAidTipById(String id) {
  try {
    return firstAidTips.firstWhere((t) => t.id == id);
  } catch (_) {
    return null;
  }
}
