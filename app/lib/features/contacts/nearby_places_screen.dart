import 'package:app/core/theme/app_color.dart';
import 'package:app/core/utils/launcher_helper.dart';
import 'package:app/core/utils/service_utils.dart';
import 'package:app/features/map/widgets/emergency_contact_tile.dart';
import 'package:app/features/map/widgets/service_marker.dart';
import 'package:app/features/map/widgets/user_location_marker.dart';
import 'package:app/models/emergency_contact.dart';
import 'package:app/services/api/services_api_service.dart';
import 'package:app/services/location_preferences_service.dart';
import 'package:app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/providers/radius_provider.dart';

class NearbyPlacesScreen extends ConsumerStatefulWidget {
  final String? category;
  final String title;

  const NearbyPlacesScreen({
    super.key,
    this.category,
    this.title = 'Nearby Places',
  });

  @override
  ConsumerState<NearbyPlacesScreen> createState() => _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState extends ConsumerState<NearbyPlacesScreen> {
  double _nearbyRadiusKm = 5;
  static const LatLng _defaultCenter = LatLng(11.5564, 104.9282);
  static const double _defaultZoom = 14.0;

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng _center = _defaultCenter;
  List<EmergencyContact> _services = [];
  List<EmergencyContact> _filteredServices = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  double? _lastRadius;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _nearbyRadiusKm = await LocationPreferencesService.getRadius();
      final position = await LocationService.getCurrentLocation();
      final center = position != null
          ? LatLng(position.latitude, position.longitude)
          : _defaultCenter;

      final services = await ServicesApiService.fetchServices(
        category: widget.category,
        lat: center.latitude,
        lng: center.longitude,
        radius: _nearbyRadiusKm,
      );

      if (!mounted) return;
      setState(() {
        _center = center;
        _services = services;
        _filteredServices = _applySearch(services, _searchQuery);
        _isLoading = false;
      });
      _mapController.move(center, _mapController.camera.zoom);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshLocation() async {
    await _loadServices();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location updated'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  List<EmergencyContact> _applySearch(
    List<EmergencyContact> services,
    String query,
  ) {
    if (query.isEmpty) return services;

    final q = query.toLowerCase();
    return services.where((service) {
      return service.name.toLowerCase().contains(q) ||
          service.type.toLowerCase().contains(q) ||
          service.address.toLowerCase().contains(q) ||
          service.phone.contains(q);
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredServices = _applySearch(_services, query);
    });
  }

  List<Marker> _buildServiceMarkers() {
    return _filteredServices
        .where((service) => service.lat != 0 || service.lng != 0)
        .map((service) {
          final color = ServiceUtils.colorForType(service.type);
          final icon = ServiceUtils.iconForType(service.type);

          return Marker(
            point: LatLng(service.lat, service.lng),
            width: 40,
            height: 52,
            child: ServiceMarker(
              icon: icon,
              color: color,
              onTap: () => _showServiceSheet(service),
            ),
          );
        })
        .toList();
  }

  void _showServiceSheet(EmergencyContact service) {
    final theme = Theme.of(context);
    final color = ServiceUtils.colorForType(service.type);
    final icon = ServiceUtils.iconForType(service.type);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(90),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                CircleAvatar(
                  radius: 34,
                  backgroundColor: color,
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  service.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  ServiceUtils.labelForType(service.type),
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                if (service.address.isNotEmpty)
                  _detailRow(Icons.location_on_outlined, service.address),
                if (service.distanceKm != null)
                  _detailRow(
                    Icons.near_me_outlined,
                    '${service.distanceKm!.toStringAsFixed(1)} km away',
                  ),
                if (service.phone.isNotEmpty)
                  _detailRow(Icons.phone_rounded, service.phone),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: service.phone.isEmpty
                            ? null
                            : () => LauncherHelper.makeCall(service.phone),
                        icon: const Icon(Icons.call_rounded, size: 18),
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
                          '${service.lat},${service.lng}',
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
                      context.push('/map/detail', extra: service);
                    },
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('View Details'),
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
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = ref.watch(radiusProvider);
    final theme = Theme.of(context);
    if (_lastRadius != radius) {
      _lastRadius = radius;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadServices();
        }
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildMapLayer(),
          _buildSearchBar(theme),
          if (!_isLoading && _errorMessage == null) _buildBottomBar(theme),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_errorMessage != null) _buildErrorState(theme),
        ],
      ),
    );
  }

  Widget _buildMapLayer() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _center,
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
        CircleLayer(
          circles: [
            CircleMarker(
              point: _center,
              radius: _nearbyRadiusKm * 1000,
              useRadiusInMeter: true,
              color: AppColors.red.withAlpha(20),
              borderColor: AppColors.red.withAlpha(90),
              borderStrokeWidth: 2,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            ..._buildServiceMarkers(),
            Marker(
              point: _center,
              width: 32,
              height: 32,
              child: const UserLocationMarker(),
            ),
          ],
        ),
        const RichAttributionWidget(
          popupInitialDisplayDuration: Duration(seconds: 0),
          attributions: [],
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      top: 5,
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
                  hintText: 'Search ${widget.title.toLowerCase()}...',
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

            GestureDetector(
              onTap: _refreshLocation,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.red.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  size: 18,
                  color: AppColors.red,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: _showServicesList,
        onVerticalDragStart: (_) => _showServicesList(),
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
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.place_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_filteredServices.length} within ${_nearbyRadiusKm.toStringAsFixed(0)} km',
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

  void _showServicesList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72,
          minChildSize: 0.35,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;

            return Column(
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
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${_filteredServices.length} found',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.textSecondary,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Within ${_nearbyRadiusKm.toStringAsFixed(0)} km',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.textSecondary,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 8),
                          ..._filteredServices.map(
                            (service) => EmergencyContactTile(
                              contact: service,
                              onTap: () {
                                Navigator.pop(sheetContext);
                                _showServiceSheet(service);
                              },
                              onNotifyTap: service.phone.isEmpty
                                  ? null
                                  : () =>
                                        LauncherHelper.makeCall(service.phone),
                            ),
                          ),
                          if (_filteredServices.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text(
                                  _searchQuery.isEmpty
                                      ? 'No services found within 5 km.'
                                      : 'No results for "$_searchQuery".',
                                  textAlign: TextAlign.center,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
              'Could not load nearby services',
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
              onPressed: _loadServices,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
