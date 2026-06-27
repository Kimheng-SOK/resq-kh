import 'package:app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/models/incident_type_model.dart';
import 'package:app/services/emergency_report_service.dart';
import 'package:app/services/location_service.dart';

/// Maps an incident type icon-name to its localized display label.
String _incidentLabel(AppLocalizations l10n, String iconName) {
  switch (iconName) {
    case 'fire': return l10n.incidentFire;
    case 'car_crash': return l10n.incidentCarCrash;
    case 'medical': return l10n.incidentMedical;
    case 'police': return l10n.incidentPolice;
    case 'water': return l10n.incidentWater;
    case 'storm': return l10n.incidentStorm;
    case 'shield': return l10n.incidentShield;
    case 'bolt': return l10n.incidentBolt;
    default: return l10n.incidentUnknown;
  }
}

class EmergencyReportForm extends StatefulWidget {
  final IncidentType incidentType;

  const EmergencyReportForm({super.key, required this.incidentType});

  @override
  State<EmergencyReportForm> createState() => _EmergencyReportFormState();
}

class _EmergencyReportFormState extends State<EmergencyReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descController = TextEditingController();

  double? _lat;
  double? _lng;
  bool _loadingLocation = true;
  bool _submitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (!mounted) return;
    setState(() {
      _lat = position?.latitude;
      _lng = position?.longitude;
      _loadingLocation = false;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    try {
      await EmergencyReportService.submitReport(
        incidentTypeId: widget.incidentType.id,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        description: _descController.text.trim(),
        lat: _lat,
        lng: _lng,
      );

      if (!mounted) return;
      _showSuccess();
    } catch (e) {
      setState(() => _submitError = AppLocalizations.of(context)!.failedToSendReport);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 10),
              Text(l10n.reportSent),
            ],
          ),
          content: Text(
            l10n.reportSentMessage,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // close dialog
                context.go('/'); // back to home
              },
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_incidentLabel(l10n, widget.incidentType.iconName)),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Selected incident banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.reporting(_incidentLabel(l10n, widget.incidentType.iconName)),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.yourName,
                border: const OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.nameIsRequired
                  : null,
            ),
            const SizedBox(height: 16),

            // Phone
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.phoneNumber,
                border: const OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.phoneIsRequired
                  : null,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.whatHappened,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),

            // Location status
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _loadingLocation
                        ? Icons.location_searching
                        : (_lat != null
                              ? Icons.location_on
                              : Icons.location_off),
                    color: _loadingLocation
                        ? Colors.orange
                        : (_lat != null ? Colors.green : Colors.red),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _loadingLocation
                          ? l10n.detectingLocation
                          : (_lat != null
                                ? l10n.locationDetected(_lat!, _lng!)
                                : l10n.locationUnavailable),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            if (_submitError != null) ...[
              const SizedBox(height: 12),
              Text(_submitError!, style: const TextStyle(color: Colors.red)),
            ],

            const SizedBox(height: 28),

            // Submit button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        l10n.sendEmergencyReport,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
