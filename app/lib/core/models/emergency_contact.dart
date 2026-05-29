/// User's personal emergency contact stored locally
class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String? relationship;
  final bool isPriority; // show at top

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    this.relationship,
    this.isPriority = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'relationship': relationship ?? '',
        'isPriority': isPriority,
      };

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      relationship: (json['relationship'] as String?)?.isNotEmpty == true
          ? json['relationship'] as String
          : null,
      isPriority: (json['isPriority'] as bool?) ?? false,
    );
  }

  EmergencyContact copyWith({
    String? id,
    String? name,
    String? phone,
    String? relationship,
    bool? isPriority,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      isPriority: isPriority ?? this.isPriority,
    );
  }
}
