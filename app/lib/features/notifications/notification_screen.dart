import 'package:app/models/emergency_report_model.dart';
import 'package:app/services/emergency_report_service.dart';
import 'package:flutter/material.dart';

import 'widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<EmergencyReport>> _reports;

  @override
  void initState() {
    super.initState();
    _reports = EmergencyReportService.getMyReports();
  }

  Future<void> _refresh() async {
    setState(() {
      _reports = EmergencyReportService.getMyReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<EmergencyReport>>(
          future: _reports,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final reports = snapshot.data ?? [];

            if (reports.isEmpty) {
              return const Center(
                child: Text(
                  "No notifications yet.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                return NotificationCard(report: reports[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
