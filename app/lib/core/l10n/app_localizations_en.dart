// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveAndContinue => 'Save & Continue';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get retry => 'Retry';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get ok => 'OK';

  @override
  String get call => 'Call';

  @override
  String get directions => 'Directions';

  @override
  String get viewDetails => 'View Details';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get add => 'Add';

  @override
  String get addContact => 'Add contact';

  @override
  String get refresh => 'Refresh';

  @override
  String get clear => 'Clear';

  @override
  String get contact => 'Contact';

  @override
  String get phone => 'Phone';

  @override
  String get navHome => 'Home';

  @override
  String get navMap => 'Map';

  @override
  String get navContacts => 'Contacts';

  @override
  String get navFirstAid => 'First Aid';

  @override
  String get navSOS => 'SOS';

  @override
  String get heyGreeting => 'Hey!';

  @override
  String get guestLabel => 'GUEST';

  @override
  String get createAccount => 'Create Account';

  @override
  String get welcomeToResq => 'Welcome to RESQ';

  @override
  String get createAccountToContinue => 'Create your account to continue';

  @override
  String get fullName => 'Full Name';

  @override
  String get emailOptional => 'Email (Optional)';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get phoneNumberHint => '+855 XX XXX XXX';

  @override
  String get continueLabel => 'Continue';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get enterOtpSent => 'Enter the OTP sent to your phone number';

  @override
  String get otpLabel => 'OTP';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get pleaseEnterOtp => 'Please enter OTP';

  @override
  String get nameAndPhoneRequired => 'Name and Phone Number are required';

  @override
  String get failedToSendOtp => 'Failed to send OTP. Please try again.';

  @override
  String get enableLocation => 'Enable Location';

  @override
  String get locationExplanation =>
      'RESQ uses your location to quickly connect you with nearby emergency services and provide faster assistance during emergencies.';

  @override
  String get allowLocation => 'Allow Location';

  @override
  String get locationServiceDisabled => 'Location service is disabled';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get userFallback => 'User';

  @override
  String get tapForHelpOrHold =>
      'Tap for emergency help or hold to report an incident';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get policeStation => 'Police Station';

  @override
  String get hospital => 'Hospital';

  @override
  String get fireStation => 'Fire Station';

  @override
  String get ambulance => 'Ambulance';

  @override
  String get nearby => 'Nearby';

  @override
  String get emergency => 'EMERGENCY';

  @override
  String get emergencyConfirm =>
      'This will immediately call the national emergency hotline.\n\nAre you sure you need emergency help?';

  @override
  String get call119 => 'CALL 119';

  @override
  String noServiceAvailable(String label) {
    return 'No $label entries are available right now.';
  }

  @override
  String get noPhoneNumber => 'This service does not have a phone number yet.';

  @override
  String get unableToCall => 'Unable to place the call right now.';

  @override
  String get noGeneralContacts => 'No general contacts have been saved yet.';

  @override
  String get noContactPhone =>
      'The selected contact does not have a phone number.';

  @override
  String get unableToLoadContacts =>
      'Unable to load your saved contacts right now.';

  @override
  String get searchContactsServices => 'Search contacts, services...';

  @override
  String get seekHelp => 'Seek Help';

  @override
  String nearbyCount(int n) {
    return '$n nearby';
  }

  @override
  String get emergencyContacts => 'EMERGENCY CONTACTS';

  @override
  String noResultsForQuery(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get noCategoryContacts => 'No contacts in this category.';

  @override
  String get addContacts => 'Add contacts';

  @override
  String get couldNotLoadContacts => 'Could not load contacts';

  @override
  String noLocationOnMap(String name) {
    return '$name has no location on map';
  }

  @override
  String notificationsEnabledFor(String name) {
    return 'Notifications enabled for $name';
  }

  @override
  String get callEmergency => 'CALL EMERGENCY';

  @override
  String get open24Hours => 'OPEN 24 HOURS';

  @override
  String noServicesFoundWithin(int km) {
    return 'No services found within $km km.';
  }

  @override
  String withinKm(int km) {
    return 'Within $km km';
  }

  @override
  String foundCount(int n) {
    return '$n found';
  }

  @override
  String get locationUpdated => 'Location updated';

  @override
  String get couldNotLoadNearby => 'Could not load nearby services';

  @override
  String get noServicesFound => 'No services found.';

  @override
  String get couldNotLoadServices => 'Could not load services';

  @override
  String get contactsLabel => 'Contacts';

  @override
  String get policeLabel => 'Police';

  @override
  String get fireLabel => 'Fire';

  @override
  String get otherLabel => 'Other';

  @override
  String get notifyThisContact => 'Notify this contact';

  @override
  String get emergencyServices => 'Emergency Services';

  @override
  String get servicesNearYou => 'Services near your location';

  @override
  String get requestAssistance => 'Request immediate assistance';

  @override
  String get erAndTrauma => 'Emergency rooms & trauma centers';

  @override
  String get medicalAndParamedics => 'Medical & paramedics';

  @override
  String get fireAndRescue => 'Fire & rescue emergencies';

  @override
  String get personalEmergencyContacts => 'Personal emergency contacts';

  @override
  String get generalContact => 'General Contact';

  @override
  String savedEmergencyContacts(int n) {
    return '$n saved emergency contacts';
  }

  @override
  String get searchContacts => 'Search contacts';

  @override
  String get noContactsFound => 'No contacts found';

  @override
  String get noEmergencyContacts => 'No emergency contacts yet';

  @override
  String get tryDifferentSearch =>
      'Try a different name, phone, or relationship.';

  @override
  String get addFamilyOrTrusted =>
      'Add family or trusted contacts you can reach quickly.';

  @override
  String get contactAdded => 'Contact added';

  @override
  String get contactUpdated => 'Contact updated';

  @override
  String get contactDeleted => 'Contact deleted';

  @override
  String get deleteContact => 'Delete contact';

  @override
  String removeFromContacts(String name) {
    return 'Remove $name from your emergency contacts?';
  }

  @override
  String get nameRequired => 'Name is required';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get relationshipRequired => 'Relationship is required';

  @override
  String get addContactTitle => 'Add Contact';

  @override
  String get editContactTitle => 'Edit Contact';

  @override
  String get name => 'Name';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get relationship => 'Relationship';

  @override
  String get contactActions => 'Contact actions';

  @override
  String get settings => 'Settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get profile => 'Profile';

  @override
  String get editProfileLabel => 'Edit Profile';

  @override
  String get medicalInfo => 'Medical Info';

  @override
  String get nearbySearchRadius => 'Nearby Search Radius';

  @override
  String get locationPermission => 'Location Permission';

  @override
  String get openAppSettingsNotSupported =>
      'Opening app settings is not supported on this platform.';

  @override
  String get notifications => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get emailAlerts => 'Email Alerts';

  @override
  String get account => 'Account';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirm =>
      'Are you sure you want to delete your account?';

  @override
  String get deleteAccountWarning => 'This action cannot be undone.';

  @override
  String typeToConfirm(String name) {
    return 'Type \"$name\" to confirm';
  }

  @override
  String get failedToDeleteAccount =>
      'Failed to delete account. Please try again.';

  @override
  String get medicalInformation => 'Medical Information';

  @override
  String get editMedicalInfo => 'Edit Medical Info';

  @override
  String get emergencyInfo => 'Emergency Info';

  @override
  String get emergencyInfoDesc =>
      'This helps emergency responders provide the right assistance quickly.';

  @override
  String get bloodType => 'Blood Type';

  @override
  String get allergies => 'Allergies';

  @override
  String get medicalConditions => 'Medical Conditions';

  @override
  String get knownAllergies => 'Known allergies';

  @override
  String get allergiesHint => 'e.g., Penicillin, Peanuts, Latex';

  @override
  String get ongoingConditions => 'Ongoing conditions';

  @override
  String get conditionsHint => 'e.g., Asthma, Diabetes, Heart condition';

  @override
  String get optional => 'Optional';

  @override
  String get selectBloodType => 'Please select your blood type';

  @override
  String get failedToSaveProfile => 'Failed to save profile. Please try again.';

  @override
  String get requiredIndicator => '*';

  @override
  String get reportSent => 'Report Sent';

  @override
  String get reportSentMessage =>
      'Your emergency report has been submitted. Help is being notified.';

  @override
  String reporting(String label) {
    return 'Reporting: $label';
  }

  @override
  String get yourName => 'Your Name';

  @override
  String get whatHappened => 'What happened? (optional)';

  @override
  String get detectingLocation => 'Detecting your location...';

  @override
  String locationDetected(double lat, double lng) {
    return 'Location detected: $lat, $lng';
  }

  @override
  String get locationUnavailable => 'Location unavailable — please enable GPS';

  @override
  String get sendEmergencyReport => 'SEND EMERGENCY REPORT';

  @override
  String get nameIsRequired => 'Name is required';

  @override
  String get phoneIsRequired => 'Phone number is required';

  @override
  String get failedToSendReport => 'Failed to send report. Please try again.';

  @override
  String get immediateActionRequired => 'IMMEDIATE ACTION REQUIRED';

  @override
  String get immediateActionBody =>
      'Select the condition below to start life-saving protocols. Call emergency services immediately if not already done.';

  @override
  String get call119Now => 'CALL 119 NOW';

  @override
  String get emergencyHotlineDesc => 'Emergency hotline — immediate help';

  @override
  String get callEmergency119 => 'Call emergency services 119 now';

  @override
  String get noConditionsAvailable => 'No conditions available.';

  @override
  String failedToLoadConditions(String error) {
    return 'Failed to load: $error';
  }

  @override
  String stepN(int n) {
    return 'Step $n';
  }

  @override
  String get back => 'BACK';

  @override
  String get next => 'NEXT';

  @override
  String get progress => 'Progress';

  @override
  String stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get goToPrevStep => 'Go to previous step';

  @override
  String get goToNextStep => 'Go to next step';

  @override
  String get sosCambodia => 'SOS CAMBODIA';

  @override
  String get goBackToSosHome => 'Go back to SOS Cambodia home';

  @override
  String get crucialWarning => 'CRUCIAL WARNING';

  @override
  String get startSteps => 'START STEPS';

  @override
  String get topicNotFound => 'Topic not found';

  @override
  String get noNotificationsYet => 'No notifications yet.';

  @override
  String get servicePolice => 'Police';

  @override
  String get serviceHospital => 'Hospital';

  @override
  String get serviceFireStation => 'Fire Station';

  @override
  String get serviceAmbulance => 'Ambulance';

  @override
  String get serviceHelpline => 'Helpline';

  @override
  String get serviceDisasterResponse => 'Disaster Response';

  @override
  String get serviceNearbyPlaces => 'Nearby Places';

  @override
  String get serviceGeneralContact => 'General Contact';

  @override
  String get servicePlaceholder => 'Service';

  @override
  String get privacyPolicyTitle => 'ResQ-KH Privacy Policy';

  @override
  String get privacyLastUpdated => 'Last Updated: June 2026';

  @override
  String get privacySection1Title => '1. Introduction';

  @override
  String get privacySection1Body =>
      'ResQ-KH is an accessibility-first emergency assistance application developed as a university project. Your privacy is important to us. This policy explains how your information is collected and used while using the application.';

  @override
  String get privacySection2Title => '2. Information We Collect';

  @override
  String get privacySection2Body =>
      'We may collect:\n\n• Full Name\n• Phone Number\n• Email Address (optional)\n• Current Location (only when permission is granted)\n• Emergency Reports submitted through the application\n• App preferences such as language and theme.';

  @override
  String get privacySection3Title => '3. Why We Collect Your Information';

  @override
  String get privacySection3Body =>
      'Your information is collected only to:\n\n• Create your account\n• Verify your identity using OTP\n• Submit emergency reports\n• Help emergency responders locate incidents\n• Improve the overall user experience.';

  @override
  String get privacySection4Title => '4. Location Permission';

  @override
  String get privacySection4Body =>
      'Your location is only accessed after your permission has been granted. The location is used solely to assist emergency reporting and nearby emergency service recommendations.';

  @override
  String get privacySection5Title => '5. Data Sharing';

  @override
  String get privacySection5Body =>
      'Emergency reports may be shared with emergency service providers such as hospitals, police stations, fire departments, or ambulance services for demonstration purposes within this academic project. We do not sell or share your personal information with third-party advertisers.';

  @override
  String get privacySection6Title => '6. Data Security';

  @override
  String get privacySection6Body =>
      'We take reasonable measures to protect your information. However, as this application is developed for educational purposes, absolute security cannot be guaranteed.';

  @override
  String get privacySection7Title => '7. Your Rights';

  @override
  String get privacySection7Body =>
      'You may:\n\n• Update your personal information.\n• Request deletion of your account.\n• Withdraw location permission at any time through your device settings.';

  @override
  String get privacySection8Title => '8. Changes to this Policy';

  @override
  String get privacySection8Body =>
      'This Privacy Policy may be updated from time to time. Any significant changes will be reflected within the application.';

  @override
  String get privacySection9Title => '9. Contact';

  @override
  String get privacySection9Body =>
      'If you have questions regarding this Privacy Policy, please contact the ResQ-KH development team.\n\nEmail: support@resq-kh.local';

  @override
  String get privacyCopyright => '© 2026 ResQ-KH';

  @override
  String get resq => 'RESQ';

  @override
  String get emergencyResponseSystem => 'Emergency Response System';

  @override
  String get appLanguage => 'App Language';

  @override
  String get selectEmergencyType => 'Select Emergency Type';

  @override
  String get whatKindOfHelp => 'What kind of help do you need?';

  @override
  String kmAway(double km) {
    return '$km km away';
  }

  @override
  String get sosEmergency => 'Emergency';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';
}
