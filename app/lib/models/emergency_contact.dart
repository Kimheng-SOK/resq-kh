class EmergencyContact {
  final String id;
  final String name;
  final String type;
  final String phone;
  final String address;
  final String hours;
  final List<String> services;
  final double lat;
  final double lng;
  final double? distanceKm;
 
  const EmergencyContact({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.address,
    required this.hours,
    required this.services,
    required this.lat,
    required this.lng,
    this.distanceKm,
  });
 
  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      hours: json['hours'] as String,
      services: List<String>.from(json['services'] ?? []),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      distanceKm: json['distanceKm'] != null
          ? (json['distanceKm'] as num).toDouble()
          : null,
    );
  }

  /// Creates an [EmergencyContact] from the backend /services API response.
  /// The backend uses `category` (enum), `phone_number`, `latitude`/`longitude`
  /// (decimal strings), and optional `description`/`distance_km`.
  factory EmergencyContact.fromServiceJson(Map<String, dynamic> json) {
    // Map backend category enum to app type string
    final rawCategory = json['category'] as String? ?? 'contact';
    final type = switch (rawCategory) {
      'fire_station' => 'fire',
      'contact' => 'helpline',
      _ => rawCategory,
    };

    // Parse services from server; fall back to derived list if server
    // doesn't provide them yet.
    final serverServices = json['services'];
    final services = serverServices is List
        ? serverServices.map((s) => s.toString()).toList()
        : _servicesForCategory(type);

    return EmergencyContact(
      id: json['id'] as String,
      name: json['name'] as String,
      type: type,
      phone: (json['phone_number'] as String?) ?? '',
      address: (json['address'] as String?) ?? '',
      hours: (json['hours'] as String?) ?? '24/7',
      services: services,
      lat: double.parse((json['latitude'] as String?) ?? '0'),
      lng: double.parse((json['longitude'] as String?) ?? '0'),
      distanceKm: json['distance_km'] != null
          ? (json['distance_km'] as num).toDouble()
          : null,
    );
  }

  /// Derives a list of service tags from the category type.
  static List<String> _servicesForCategory(String type) {
    switch (type) {
      case 'police':
        return ['Emergency Response', 'Crime Reporting', 'Public Order'];
      case 'hospital':
        return ['Emergency', 'Surgery', 'ICU', 'Outpatient'];
      case 'fire':
        return ['Fire Suppression', 'Rescue', 'Emergency Response'];
      case 'ambulance':
        return ['Emergency Medical Transport', 'On-site First Aid'];
      case 'helpline':
        return ['Counseling', 'Referral Services'];
      case 'disaster':
        return ['Disaster Relief', 'Search & Rescue'];
      default:
        return ['Emergency Assistance'];
    }
  }
 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'phone': phone,
      'address': address,
      'hours': hours,
      'services': services,
      'lat': lat,
      'lng': lng,
      if (distanceKm != null) 'distanceKm': distanceKm,
    };
  }
 
  EmergencyContact copyWith({
    String? id,
    String? name,
    String? type,
    String? phone,
    String? address,
    String? hours,
    List<String>? services,
    double? lat,
    double? lng,
    double? distanceKm,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      hours: hours ?? this.hours,
      services: services ?? this.services,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
 
  @override
  String toString() {
    return 'EmergencyContact(id: $id, name: $name, type: $type, '
        'phone: $phone, address: $address, hours: $hours, '
        'services: $services, lat: $lat, lng: $lng, distanceKm: $distanceKm)';
  }
 
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmergencyContact && other.id == id;
  }
 
  @override
  int get hashCode => id.hashCode;
}