import 'package:app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_color.dart';
import '../../core/utils/service_utils.dart';
import '../../features/contacts/models/contacts_model.dart';
import '../../models/emergency_contact.dart';
import '../../services/api/services_api_service.dart';
import '../../services/contact_service.dart';
import '../../services/emergency_repository.dart';
import 'widgets/service_marker.dart';
import 'widgets/user_location_marker.dart';
import 'widgets/seek_help_row.dart';
import 'widgets/emergency_contact_tile.dart';

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
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  static const LatLng _fallbackCenter = LatLng(11.5564, 104.9282);
  LatLng _userLocation = _fallbackCenter;
  static const double _defaultZoom = 14.0;

  @override
  void initState() {
    super.initState();

    _loadCurrentLocation().then((_) {
      _loadContacts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    final position = await LocationService.getCurrentLocation();

    if (position == null) return;

    final location = LatLng(position.latitude, position.longitude);

    if (!mounted) return;

    setState(() {
      _userLocation = location;
    });

    _mapController.move(location, 15);
  }

  Future<void> _loadContacts() async {
    try {
      // Fetch backend services and personal contacts in parallel
      final results = await Future.wait(<Future<List<EmergencyContact>>>[
        ServicesApiService.fetchServices(
          lat: _userLocation.latitude,
          lng: _userLocation.longitude,
          radius: 50,
        ),
        _loadPersonalContacts(),
      ]);

      final services = results[0];
      final personal = results[1];

      if (!mounted) return;
      setState(() {
        _allContacts = [...services, ...personal];
        _filteredContacts = _allContacts;
        _isLoading = false;
      });
    } catch (_) {
      // Fallback to local JSON if API is unreachable
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
  }

  /// Fetches the user's personal emergency contacts and converts them
  /// to [EmergencyContact] instances for display in the map sheet.
  Future<List<EmergencyContact>> _loadPersonalContacts() async {
    try {
      final contacts = await ContactService.getContacts();
      return contacts.map((c) => _contactToEmergency(c)).toList();
    } catch (_) {
      return [];
    }
  }

  EmergencyContact _contactToEmergency(Contact contact) {
    return EmergencyContact(
      id: contact.id,
      name: contact.name,
      type: 'contact',
      phone: contact.phoneNumber,
      address: contact.relationship,
      hours: '',
      services: const [],
      lat: 0,
      lng: 0,
    );
  }

  /// Applies both category and text-search filters together.
  List<EmergencyContact> _applyFilters({
    required String query,
    required String? categoryId,
  }) {
    var results = _allContacts;

    // Category filter
    if (categoryId != null && categoryId != 'contacts') {
      results = results.where((c) => c.type == categoryId).toList();
    }

    // Text search — matches name, type, address, phone
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      results = results.where((c) {
        return c.name.toLowerCase().contains(q) ||
            c.type.toLowerCase().contains(q) ||
            c.address.toLowerCase().contains(q) ||
            c.phone.contains(q);
      }).toList();
    }

    return results;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredContacts = _applyFilters(
        query: query,
        categoryId: _selectedCategory,
      );
    });
  }

  void _onCategorySelected(String? categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      _filteredContacts = _applyFilters(
        query: _searchQuery,
        categoryId: categoryId,
      );
    });
  }

  List<Marker> _buildMarkers() {
    return _filteredContacts.where((c) => c.lat != 0 || c.lng != 0).map((
      contact,
    ) {
      final color = ServiceUtils.colorForType(contact.type);
      final icon = ServiceUtils.iconForType(contact.type);

      return Marker(
        point: LatLng(contact.lat, contact.lng),
        width: 40,
        height: 52,
        child: ServiceMarker(
          icon: icon,
          color: color,
          onTap: () => _onContactTap(contact),
        ),
      );
    }).toList();
  }

  Marker _buildUserMarker() {
    return Marker(
      point: _userLocation,
      width: 32,
      height: 32,
      child: UserLocationMarker(),
    );
  }

  void _onContactTap(EmergencyContact contact) {
    if (contact.lat == 0 && contact.lng == 0) {
      // Personal contact without location — can't show on map
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noLocationOnMap(contact.name))),
      );
      return;
    }
    context.push('/map/detail', extra: contact);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildMapLayer(),

          _buildSearchBar(theme, l10n),

          if (!_isLoading && _errorMessage == null)
            _buildBottomIndicator(theme, l10n),

          if (_isLoading) const Center(child: CircularProgressIndicator()),

          if (_errorMessage != null) _buildErrorState(theme, l10n),
        ],
      ),
    );
  }

  Widget _buildMapLayer() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _userLocation,
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
        MarkerLayer(markers: [..._buildMarkers(), _buildUserMarker()]),
        // Hide default attribution for cleaner UI
        const RichAttributionWidget(
          popupInitialDisplayDuration: Duration(seconds: 0),
          attributions: [],
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme, AppLocalizations l10n) {
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
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
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: l10n.searchContactsServices,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                    fontSize: 14,
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
            // Clear button — shown when search is active
            SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                await _loadCurrentLocation();
                await _loadContacts();
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.my_location_rounded, color: Colors.red),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
                child: Icon(
                  Icons.close_rounded,
                  color: isDark ? Colors.white54 : AppColors.textSecondary,
                  size: 20,
                ),
              ),
            const SizedBox(width: 8),
            // Tune icon — shows active filter indicator
            GestureDetector(
              onTap: () => _showContactsSheet(context),
              child: Icon(
                Icons.tune_rounded,
                color: _selectedCategory != null
                    ? AppColors.red
                    : isDark
                    ? Colors.white54
                    : AppColors.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIndicator(ThemeData theme, AppLocalizations l10n) {
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                    l10n.seekHelp,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const Spacer(),
                  if (_searchQuery.isNotEmpty)
                    Text(
                      '"$_searchQuery" · ${_filteredContacts.length}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.red,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    )
                  else
                    Text(
                      l10n.nearbyCount(_filteredContacts.length),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white54
                            : AppColors.textSecondary,
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

  void _showContactsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _ContactsSheetContent(
          allContacts: _allContacts,
          initialSearchQuery: _searchQuery,
          initialCategory: _selectedCategory,
          onContactTap: (contact) {
            Navigator.pop(sheetContext);
            _onContactTap(contact);
          },
          onAddContacts: () {
            Navigator.pop(sheetContext);
            context.push('/contacts');
          },
          onSearchChanged: (query) {
            _onSearchChanged(query);
          },
          onCategoryChanged: (categoryId) {
            _onCategorySelected(categoryId);
          },
        );
      },
    );
  }

  Widget _buildErrorState(ThemeData theme, AppLocalizations l10n) {
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
            l10n.couldNotLoadContacts,
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
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _ContactsSheetContent extends StatefulWidget {
  final List<EmergencyContact> allContacts;
  final ValueChanged<EmergencyContact> onContactTap;
  final VoidCallback onAddContacts;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String> onSearchChanged;
  final String? initialCategory;
  final String initialSearchQuery;

  const _ContactsSheetContent({
    required this.allContacts,
    required this.onContactTap,
    required this.onAddContacts,
    required this.onCategoryChanged,
    required this.onSearchChanged,
    this.initialCategory,
    this.initialSearchQuery = '',
  });

  @override
  State<_ContactsSheetContent> createState() => _ContactsSheetContentState();
}

class _ContactsSheetContentState extends State<_ContactsSheetContent> {
  late String? _selectedCategory;
  late String _searchQuery;
  late List<EmergencyContact> _filtered;
  final TextEditingController _sheetSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _searchQuery = widget.initialSearchQuery;
    _sheetSearchController.text = widget.initialSearchQuery;
    _filtered = _applyFilters();
  }

  @override
  void dispose() {
    _sheetSearchController.dispose();
    super.dispose();
  }

  List<EmergencyContact> _applyFilters() {
    var results = widget.allContacts;

    // Category filter
    if (_selectedCategory != null && _selectedCategory != 'contacts') {
      results = results.where((c) => c.type == _selectedCategory).toList();
    }

    // Text search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      results = results.where((c) {
        return c.name.toLowerCase().contains(q) ||
            c.type.toLowerCase().contains(q) ||
            c.address.toLowerCase().contains(q) ||
            c.phone.contains(q);
      }).toList();
    }

    return results;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filtered = _applyFilters();
    });
    widget.onSearchChanged(query);
  }

  void _onCategoryTap(String? categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      _filtered = _applyFilters();
    });
    widget.onCategoryChanged(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(120),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

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
                      // ── Search bar inside the sheet ──────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2C2C2C)
                                : const Color(0xFFF3F3F4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _sheetSearchController,
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: l10n.searchContactsServices,
                              hintStyle: TextStyle(
                                color: isDark
                                    ? Colors.white38
                                    : const Color(0xFF9CA3AF),
                                fontSize: 14,
                                fontFamily: 'SF Pro Display',
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary,
                                size: 20,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        _sheetSearchController.clear();
                                        _onSearchChanged('');
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: isDark
                                            ? Colors.white54
                                            : AppColors.textSecondary,
                                        size: 18,
                                      ),
                                    )
                                  : null,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 15,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── "Seek Help" header ────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Text(
                              l10n.seekHelp,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              l10n.foundCount(_filtered.length),
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const SizedBox(width: 4),
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

                      SeekHelpRow(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: _onCategoryTap,
                      ),

                      const SizedBox(height: 16),

                      const Divider(height: 1, indent: 24, endIndent: 24),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          l10n.emergencyContacts,
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
                                    l10n.notificationsEnabledFor(contact.name),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      if (_filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 40,
                                  color: isDark
                                      ? Colors.white38
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? l10n.noResultsForQuery(_searchQuery)
                                      : l10n.noCategoryContacts,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white54
                                        : AppColors.textSecondary,
                                    fontSize: 15,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: OutlinedButton.icon(
                          onPressed: widget.onAddContacts,
                          icon: const Icon(Icons.person_add_rounded, size: 20),
                          label: Text(
                            l10n.addContacts,
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
