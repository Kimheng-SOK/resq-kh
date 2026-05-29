import '../models/emergency_service.dart';

/// Mock emergency services data for Phnom Penh, Cambodia
const List<EmergencyService> mockPoliceServices = [
  EmergencyService(
    id: 'police-1',
    name: 'Phnom Penh Police Commissariat',
    type: 'police',
    phone: '012999999',
    address: 'St. 47, Sangkat Srah Chak, Khan Daun Penh, Phnom Penh',
    hours: '24/7',
    servicesOffered: ['Emergency Response', 'Crime Report', 'Traffic Control'],
    latitude: 11.5734,
    longitude: 104.9218,
    distanceKm: 0.8,
  ),
  EmergencyService(
    id: 'police-2',
    name: 'Khan Chamkarmon Police Station',
    type: 'police',
    phone: '012888888',
    address: 'St. 163, Sangkat Toul Tompoung, Khan Chamkarmon, Phnom Penh',
    hours: '24/7',
    servicesOffered: ['Emergency Response', 'Crime Report'],
    latitude: 11.5432,
    longitude: 104.9123,
    distanceKm: 2.1,
  ),
  EmergencyService(
    id: 'police-3',
    name: 'Khan Toul Kork Police Station',
    type: 'police',
    phone: '012777777',
    address: 'St. 289, Sangkat Boeung Kak II, Khan Toul Kork, Phnom Penh',
    hours: '24/7',
    servicesOffered: ['Emergency Response', 'Traffic Control'],
    latitude: 11.5823,
    longitude: 104.8823,
    distanceKm: 3.5,
  ),
  EmergencyService(
    id: 'police-4',
    name: 'Khan Meanchey Police Post',
    type: 'police',
    phone: '012666666',
    address: 'St. Veng Sreng, Sangkat Steung Meanchey, Khan Meanchey, Phnom Penh',
    hours: '06:00 - 22:00',
    servicesOffered: ['Crime Report', 'Community Policing'],
    latitude: 11.5234,
    longitude: 104.8890,
    distanceKm: 4.8,
  ),
  EmergencyService(
    id: 'police-5',
    name: 'Khan Sen Sok Police Station',
    type: 'police',
    phone: '012555555',
    address: 'St. 1986, Sangkat Phnom Penh Thmey, Khan Sen Sok, Phnom Penh',
    hours: '24/7',
    servicesOffered: ['Emergency Response', 'Crime Report'],
    latitude: 11.5923,
    longitude: 104.8423,
    distanceKm: 6.2,
  ),
];

const List<EmergencyService> mockHospitalServices = [
  EmergencyService(
    id: 'hospital-1',
    name: 'Calmette Hospital',
    type: 'hospital',
    phone: '023426948',
    address: 'No.3 Monivong Blvd, Khan Daun Penh, Phnom Penh',
    hours: '24/7 Emergency',
    servicesOffered: [
      'Emergency Room',
      'Surgery',
      'ICU',
      'Cardiology',
      'Trauma Center'
    ],
    latitude: 11.5765,
    longitude: 104.9187,
    distanceKm: 0.5,
  ),
  EmergencyService(
    id: 'hospital-2',
    name: 'Khmer-Soviet Friendship Hospital',
    type: 'hospital',
    phone: '023217989',
    address: 'St. 271, Khan Chamkarmon, Phnom Penh',
    hours: '24/7 Emergency',
    servicesOffered: [
      'Emergency Room',
      'Internal Medicine',
      'Surgery',
      'Pediatrics'
    ],
    latitude: 11.5432,
    longitude: 104.9021,
    distanceKm: 2.0,
  ),
  EmergencyService(
    id: 'hospital-3',
    name: 'Preah Kossamak Hospital',
    type: 'hospital',
    phone: '023723434',
    address: 'St. 63, Khan Daun Penh, Phnom Penh',
    hours: '24/7 Emergency',
    servicesOffered: [
      'Emergency Room',
      'Obstetrics',
      'Gynecology',
      'Neonatal ICU'
    ],
    latitude: 11.5689,
    longitude: 104.9256,
    distanceKm: 1.5,
  ),
  EmergencyService(
    id: 'hospital-4',
    name: 'Royal Phnom Penh Hospital',
    type: 'hospital',
    phone: '023991000',
    address: 'Russian Federation Blvd, Khan Sen Sok, Phnom Penh',
    hours: '24/7',
    servicesOffered: [
      'Emergency Room',
      'ICU',
      'Cardiology',
      'Orthopedics',
      'International Clinic'
    ],
    latitude: 11.5823,
    longitude: 104.8532,
    distanceKm: 4.3,
  ),
  EmergencyService(
    id: 'hospital-5',
    name: 'Sihanouk Hospital Center of Hope',
    type: 'hospital',
    phone: '023887883',
    address: 'St. 134, Khan Daun Penh, Phnom Penh',
    hours: '24/7 Emergency (Free)',
    servicesOffered: [
      'Emergency Room',
      'Free Clinic',
      'HIV/AIDS Care',
      'Internal Medicine'
    ],
    latitude: 11.5712,
    longitude: 104.9134,
    distanceKm: 0.9,
  ),
];

const List<EmergencyService> mockFireServices = [
  EmergencyService(
    id: 'fire-1',
    name: 'Phnom Penh Fire Department HQ',
    type: 'fire',
    phone: '666',
    address: 'St. 63, Sangkat Chaktomuk, Khan Daun Penh, Phnom Penh',
    hours: '24/7',
    servicesOffered: [
      'Fire Suppression',
      'Rescue Operations',
      'Hazmat Response'
    ],
    latitude: 11.5723,
    longitude: 104.9234,
    distanceKm: 1.2,
  ),
  EmergencyService(
    id: 'fire-2',
    name: 'Khan Chamkarmon Fire Station',
    type: 'fire',
    phone: '023987654',
    address: 'St. 360, Sangkat Boeung Keng Kang III, Khan Chamkarmon, Phnom Penh',
    hours: '24/7',
    servicesOffered: ['Fire Suppression', 'Rescue Operations'],
    latitude: 11.5432,
    longitude: 104.9156,
    distanceKm: 2.5,
  ),
  EmergencyService(
    id: 'fire-3',
    name: 'Khan Russey Keo Fire Post',
    type: 'fire',
    phone: '023876543',
    address: 'National Road 5, Sangkat Russey Keo, Khan Russey Keo, Phnom Penh',
    hours: '06:00 - 22:00',
    servicesOffered: ['Fire Suppression'],
    latitude: 11.5934,
    longitude: 104.9023,
    distanceKm: 3.8,
  ),
  EmergencyService(
    id: 'fire-4',
    name: 'Pochentong Fire Station',
    type: 'fire',
    phone: '023765432',
    address: 'Russian Federation Blvd, Sangkat Kakab, Khan Por Sen Chey, Phnom Penh',
    hours: '24/7',
    servicesOffered: ['Fire Suppression', 'Airport Emergency Response'],
    latitude: 11.5623,
    longitude: 104.8323,
    distanceKm: 7.2,
  ),
  EmergencyService(
    id: 'fire-5',
    name: 'Khan Meanchey Fire Post',
    type: 'fire',
    phone: '023654321',
    address: 'St. 271, Sangkat Steung Meanchey, Khan Meanchey, Phnom Penh',
    hours: '06:00 - 22:00',
    servicesOffered: ['Fire Suppression', 'Rescue Operations'],
    latitude: 11.5234,
    longitude: 104.8856,
    distanceKm: 5.1,
  ),
];

const List<EmergencyService> mockAmbulanceServices = [
  EmergencyService(
    id: 'ambulance-1',
    name: 'SAMU Emergency Ambulance',
    type: 'ambulance',
    phone: '119',
    address: 'Calmette Hospital, Monivong Blvd, Phnom Penh',
    hours: '24/7',
    servicesOffered: [
      'Emergency Transport',
      'Advanced Life Support',
      'Trauma Response'
    ],
    latitude: 11.5765,
    longitude: 104.9187,
    distanceKm: 0.5,
  ),
  EmergencyService(
    id: 'ambulance-2',
    name: 'Cambodian Red Cross Ambulance',
    type: 'ambulance',
    phone: '012234567',
    address: 'St. 271, Khan Chamkarmon, Phnom Penh',
    hours: '24/7',
    servicesOffered: [
      'Emergency Transport',
      'Disaster Response',
      'First Aid'
    ],
    latitude: 11.5498,
    longitude: 104.9087,
    distanceKm: 1.8,
  ),
  EmergencyService(
    id: 'ambulance-3',
    name: 'Royal Phnom Penh Hospital Ambulance',
    type: 'ambulance',
    phone: '023991000',
    address: 'Russian Federation Blvd, Khan Sen Sok, Phnom Penh',
    hours: '24/7',
    servicesOffered: [
      'Emergency Transport',
      'Advanced Life Support',
      'International Standards'
    ],
    latitude: 11.5823,
    longitude: 104.8532,
    distanceKm: 4.3,
  ),
  EmergencyService(
    id: 'ambulance-4',
    name: 'Preah Kossamak Ambulance Service',
    type: 'ambulance',
    phone: '023723434',
    address: 'St. 63, Khan Daun Penh, Phnom Penh',
    hours: '24/7',
    servicesOffered: ['Emergency Transport', 'Maternal Transport'],
    latitude: 11.5689,
    longitude: 104.9256,
    distanceKm: 1.5,
  ),
  EmergencyService(
    id: 'ambulance-5',
    name: 'Hope Worldwide Ambulance',
    type: 'ambulance',
    phone: '023887883',
    address: 'St. 134, Khan Daun Penh, Phnom Penh',
    hours: '24/7',
    servicesOffered: [
      'Emergency Transport',
      'Free Service',
      'Basic Life Support'
    ],
    latitude: 11.5712,
    longitude: 104.9134,
    distanceKm: 0.9,
  ),
];

/// Get services by type
List<EmergencyService> getServicesByType(String type) {
  switch (type) {
    case 'police':
      return mockPoliceServices.toList();
    case 'hospital':
      return mockHospitalServices.toList();
    case 'fire':
      return mockFireServices.toList();
    case 'ambulance':
      return mockAmbulanceServices.toList();
    default:
      return [];
  }
}

/// Get a single service by ID
EmergencyService? getServiceById(String id) {
  final all = [
    ...mockPoliceServices,
    ...mockHospitalServices,
    ...mockFireServices,
    ...mockAmbulanceServices,
  ];
  try {
    return all.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
}

/// Get all services for map display
List<EmergencyService> getAllServices() {
  return [
    ...mockPoliceServices,
    ...mockHospitalServices,
    ...mockFireServices,
    ...mockAmbulanceServices,
  ];
}
