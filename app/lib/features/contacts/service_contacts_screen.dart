import 'package:app/core/theme/app_color.dart';
import 'package:app/core/utils/launcher_helper.dart';
import 'package:app/core/utils/service_utils.dart';
import 'package:app/models/emergency_contact.dart';
import 'package:app/services/api/services_api_service.dart';
import 'package:app/widgets/refresh_drag_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceContactsScreen extends StatefulWidget {
  final String category;
  final String title;

  const ServiceContactsScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  State<ServiceContactsScreen> createState() => _ServiceContactsScreenState();
}

class _ServiceContactsScreenState extends State<ServiceContactsScreen> {
  List<EmergencyContact> _services = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final services = await ServicesApiService.fetchServices(
        category: widget.category,
      );
      if (!mounted) return;
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showDetail(EmergencyContact contact) {
    final color = ServiceUtils.colorForType(contact.type);
    final icon = ServiceUtils.iconForType(contact.type);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Avatar
              CircleAvatar(
                radius: 36,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                contact.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ServiceUtils.labelForType(contact.type),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Address row
              if (contact.address.isNotEmpty)
                _infoRow(Icons.location_on_outlined, contact.address),

              // Hours row
              if (contact.hours.isNotEmpty)
                _infoRow(Icons.access_time_rounded, contact.hours),

              // Services row
              if (contact.services.isNotEmpty)
                _infoRow(
                  Icons.medical_services_outlined,
                  contact.services.join(', '),
                ),

              const SizedBox(height: 8),

              // Phone row
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.06)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_rounded, color: AppColors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Phone',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            contact.phone,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => LauncherHelper.makeCall(contact.phone),
                      icon: const Icon(Icons.call_rounded),
                      color: AppColors.success,
                      tooltip: 'Call',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => LauncherHelper.makeCall(contact.phone),
                      icon: const Icon(Icons.phone_rounded, size: 18),
                      label: const Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => LauncherHelper.openMap(
                        '${contact.lat},${contact.lng}',
                      ),
                      icon: const Icon(Icons.directions_rounded, size: 18),
                      label: const Text('Directions'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/map/detail', extra: contact);
                  },
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: const Text('View on Map'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   centerTitle: true,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
      //     onPressed: () => context.pop(),
      //   ),
      // ),
      body: RefreshDragPopWidget(
        onRefresh: _load,
        child: _buildBody(theme, isDark),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, bool isDark) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text('Could not load services', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_services.isEmpty) {
      return const Center(
        child: Text(
          'No services found.',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ..._services.map((contact) {
          final color = ServiceUtils.colorForType(contact.type);
          final initials = contact.name.isNotEmpty
              ? contact.name[0].toUpperCase()
              : '?';

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _showDetail(contact),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: color,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(
                                Icons.phone_rounded,
                                size: 14,
                                color: isDark
                                    ? Colors.white38
                                    : AppColors.textSecondary,
                              ),

                              const SizedBox(width: 4),

                              Text(
                                contact.phone,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 44,
                      height: 44,
                      child: IconButton(
                        onPressed: () => LauncherHelper.makeCall(contact.phone),
                        icon: const Icon(Icons.phone_rounded),
                        color: AppColors.success,
                        iconSize: 22,
                        tooltip: 'Call ${contact.name}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
