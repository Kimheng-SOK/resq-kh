class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      relationship: json['relationship'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'relationship': relationship,
    };
  }
}
