import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_color.dart';
import '../../core/utils/service_utils.dart';
import '../../models/emergency_contact.dart';
import '../../services/emergency_repository.dart';
import 'widgets/contact_profile_marker.dart';
import 'widgets/service_marker.dart';
import 'widgets/user_location_marker.dart';
import 'widgets/seek_help_row.dart';
import 'widgets/emergency_contact_tile.dart';

/// The primary Map screen showing emergency service locations on an
/// OpenStreetMap, with a draggable bottom sheet listing contacts.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final EmergencyRepository _repository = EmergencyRepository();

  List<EmergencyContact> _allContacts = [];
  List<EmergencyContact> _filteredContacts = [];
  bool _isLoading = true;
  String? _errorMessage;

  String? _selectedCategory;
  final MapController _mapController = MapController();

  // Phnom Penh center
  static const LatLng _defaultCenter = LatLng(11.5564, 104.9282);
  static const double _defaultZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      final contacts = await _repository.getAll();
      if (!mounted) return;
      setState(() {
        _allContacts = contacts;
        _filteredContacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onCategorySelected(String? categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      if (categoryId == null || categoryId == 'contacts') {
        _filteredContacts = _allContacts;
      } else {
        _filteredContacts =
            _allContacts.where((c) => c.type == categoryId).toList();
      }
    });
  }

  // ── Markers ──────────────────────────────────────────────────

  List<Marker> _buildContactMarkers() {
    return _filteredContacts.map((contact) {
      final color = ServiceUtils.colorForType(contact.type);
      final initials = _initials(contact.name);

      return Marker(
        point: LatLng(contact.lat, contact.lng),
        width: 48,
        height: 56,
        child: ContactProfileMarker(
          initials: initials,
          color: color,
          onTap: () => _onContactTap(contact),
        ),
      );
    }).toList();
  }

  List<Marker> _buildServiceMarkers() {
    // Deduplicate by type — show one service marker per category
    final seenTypes = <String>{};
    final uniqueByType = _filteredContacts.where((c) {
      if (seenTypes.contains(c.type)) return false;
      seenTypes.add(c.type);
      return true;
    }).toList();

    return uniqueByType.map((contact) {
      final color = ServiceUtils.colorForType(contact.type);
      final icon = ServiceUtils.iconForType(contact.type);

      return Marker(
        point: LatLng(contact.lat, contact.lng),
        width: 36,
        height: 48,
        child: ServiceMarker(
          icon: icon,
          color: color,
          onTap: () => _onContactTap(contact),
        ),
      );
    }).toList();
  }

  Marker _buildUserMarker() {
    return const Marker(
      point: _defaultCenter,
      width: 32,
      height: 32,
      child: UserLocationMarker(),
    );
  }

  void _onContactTap(EmergencyContact contact) {
    context.push('/map/detail', extra: contact);
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── Layer 0: Map ──────────────────────────────────
          _buildMapLayer(),

          // ── Layer 4: Header gradient overlay ───────────────
          _buildHeaderOverlay(theme),

          // ── Layer 5: Search bar ────────────────────────────
          _buildSearchBar(theme),

          // ── Layer 6: Bottom collapsed indicator ─────────────
          if (!_isLoading && _errorMessage == null) _buildBottomIndicator(theme),

          // ── Loading indicator ──────────────────────────────
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),

          // ── Error state ────────────────────────────────────
          if (_errorMessage != null) _buildErrorState(theme),
        ],
      ),
    );
  }

  // ── Layer builders ───────────────────────────────────────────

  Widget _buildMapLayer() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _defaultCenter,
        initialZoom: _defaultZoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.resqkh.app',
        ),
        MarkerLayer(markers: [
          ..._buildContactMarkers(),
          ..._buildServiceMarkers(),
          _buildUserMarker(),
        ]),
        // Hide default attribution for cleaner UI
        const RichAttributionWidget(
          popupInitialDisplayDuration: Duration(seconds: 0),
          attributions: [],
        ),
      ],
    );
  }

  Widget _buildHeaderOverlay(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              (isDark ? Colors.black : Colors.white).withAlpha(230),
              (isDark ? Colors.black : Colors.white).withAlpha(0),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                // ── App icon + title ──────────────────────────
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Red SOS icon badge
                    Container(
                      width: 31,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SOS CAMBODIA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.6,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // ── Settings button ───────────────────────────
                GestureDetector(
                  onTap: () => context.push('/settings'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black54
                              : AppColors.shadow,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.settings_rounded,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black38 : AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search_rounded,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search here',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                    fontSize: 16,
                    fontFamily: 'SF Pro Display',
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
            Icon(
              Icons.mic_rounded,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.tune_rounded,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  // ── Bottom indicator (collapsed tab) ───────────────────────────

  Widget _buildBottomIndicator(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => _showContactsSheet(context),
        onVerticalDragStart: (_) => _showContactsSheet(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black45 : AppColors.shadow,
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              // Title row
              Row(
                children: [
                  const Icon(Icons.people_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Seek Help',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_filteredContacts.length} nearby',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white54 : AppColors.textSecondary,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: isDark ? Colors.white54 : AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Modal bottom sheet (same smooth drag as delete modal) ──────

  void _showContactsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _ContactsSheetContent(
          allContacts: _allContacts,
          onContactTap: (contact) {
            Navigator.pop(sheetContext);
            _onContactTap(contact);
          },
          onAddContacts: () {
            Navigator.pop(sheetContext);
            context.push('/contacts');
          },
          onCategoryChanged: (categoryId) {
            _onCategorySelected(categoryId);
          },
          initialCategory: _selectedCategory,
        );
      },
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: isDark ? Colors.white38 : AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            'Could not load contacts',
            style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Display',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _errorMessage!,
            style: TextStyle(
              color: isDark ? Colors.white54 : AppColors.textSecondary,
              fontSize: 13,
              fontFamily: 'SF Pro Display',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
              _loadContacts();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ── Contacts Sheet Content ─────────────────────────────────────────

/// The content inside the modal bottom sheet, with its own local state
/// for category filtering so the sheet rebuilds instantly on tap.
class _ContactsSheetContent extends StatefulWidget {
  final List<EmergencyContact> allContacts;
  final ValueChanged<EmergencyContact> onContactTap;
  final VoidCallback onAddContacts;
  final ValueChanged<String?> onCategoryChanged;
  final String? initialCategory;

  const _ContactsSheetContent({
    required this.allContacts,
    required this.onContactTap,
    required this.onAddContacts,
    required this.onCategoryChanged,
    this.initialCategory,
  });

  @override
  State<_ContactsSheetContent> createState() => _ContactsSheetContentState();
}

class _ContactsSheetContentState extends State<_ContactsSheetContent> {
  late String? _selectedCategory;
  late List<EmergencyContact> _filtered;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _filtered = _applyFilter(_selectedCategory);
  }

  List<EmergencyContact> _applyFilter(String? categoryId) {
    if (categoryId == null || categoryId == 'contacts') {
      return widget.allContacts;
    }
    return widget.allContacts.where((c) => c.type == categoryId).toList();
  }

  void _onCategoryTap(String? categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      _filtered = _applyFilter(categoryId);
    });
    widget.onCategoryChanged(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle bar (match delete modal style) ──────
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(120),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ── Content card ───────────────────────────────
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                    children: [
                      // ── "Seek Help" header + chevron ────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Text(
                              'Seek Help',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Category chips ──────────────────
                      SeekHelpRow(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: _onCategoryTap,
                      ),

                      const SizedBox(height: 16),

                      // ── Divider ─────────────────────────
                      const Divider(height: 1, indent: 24, endIndent: 24),

                      const SizedBox(height: 16),

                      // ── "EMERGENCY CONTACTS" header ─────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'EMERGENCY CONTACTS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.red,
                            letterSpacing: 0.5,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // ── Contact list ────────────────────
                      ..._filtered.map(
                        (contact) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: EmergencyContactTile(
                            contact: contact,
                            onTap: () => widget.onContactTap(contact),
                            onNotifyTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Notifications enabled for ${contact.name}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // ── Empty state ─────────────────────
                      if (_filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Center(
                            child: Text(
                              'No contacts found for this category.',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary,
                                fontSize: 15,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 8),

                      // ── "+ Add contacts" button ─────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: OutlinedButton.icon(
                          onPressed: widget.onAddContacts,
                          icon: const Icon(
                            Icons.person_add_rounded,
                            size: 20,
                          ),
                          label: const Text(
                            '+ Add contacts',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            foregroundColor: theme.colorScheme.onSurface,
                            side: BorderSide(
                              color: isDark ? Colors.white24 : AppColors.border,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
