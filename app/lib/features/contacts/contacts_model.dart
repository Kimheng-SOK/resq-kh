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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      relationship: json['relationship'],
    );
  }
}
