import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/models/incident_type_model.dart';
import 'package:app/features/home/widgets/emergency_radial_menu.dart';

void showEmergencyRadialMenu(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    pageBuilder: (ctx, _, __) => EmergencyRadialMenu(
      onDismiss: () => Navigator.pop(ctx),
      onSelect: (incidentType) {
        Navigator.pop(ctx);
        context.push('/emergency-report', extra: incidentType);
      },
    ),
  );
}