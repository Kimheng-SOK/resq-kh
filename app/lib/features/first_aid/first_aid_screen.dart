import 'package:flutter/material.dart';
import 'package:app/features/first_aid/widgets/urgent_notice.dart';
import 'package:app/features/first_aid/widgets/urgency_card_list.dart';
import 'package:app/features/first_aid/widgets/sos_call_button.dart';
import 'package:go_router/go_router.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  void _handleSelectCondition(BuildContext context, String id) {
    context.go('/first-aid/$id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UrgentNotice(),
                const SizedBox(height: 16),
                UrgencyCardsList(onSelect: (id) => _handleSelectCondition(context, id),),
              ],
            ),
          ),

          // Sticky bottom: SOS button + nav bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SosCallButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}