import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km'),
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get saveAndContinue;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get addContact;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get navContacts;

  /// No description provided for @navFirstAid.
  ///
  /// In en, this message translates to:
  /// **'First Aid'**
  String get navFirstAid;

  /// No description provided for @navSOS.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get navSOS;

  /// No description provided for @heyGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hey!'**
  String get heyGreeting;

  /// No description provided for @guestLabel.
  ///
  /// In en, this message translates to:
  /// **'GUEST'**
  String get guestLabel;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @welcomeToResq.
  ///
  /// In en, this message translates to:
  /// **'Welcome to RESQ'**
  String get welcomeToResq;

  /// No description provided for @createAccountToContinue.
  ///
  /// In en, this message translates to:
  /// **'Create your account to continue'**
  String get createAccountToContinue;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailOptional;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'+855 XX XXX XXX'**
  String get phoneNumberHint;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @enterOtpSent.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to your phone number'**
  String get enterOtpSent;

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otpLabel;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @pleaseEnterOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter OTP'**
  String get pleaseEnterOtp;

  /// No description provided for @nameAndPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Name and Phone Number are required'**
  String get nameAndPhoneRequired;

  /// No description provided for @failedToSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP. Please try again.'**
  String get failedToSendOtp;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get enableLocation;

  /// No description provided for @locationExplanation.
  ///
  /// In en, this message translates to:
  /// **'RESQ uses your location to quickly connect you with nearby emergency services and provide faster assistance during emergencies.'**
  String get locationExplanation;

  /// No description provided for @allowLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow Location'**
  String get allowLocation;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location service is disabled'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @userFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userFallback;

  /// No description provided for @tapForHelpOrHold.
  ///
  /// In en, this message translates to:
  /// **'Tap for emergency help or hold to report an incident'**
  String get tapForHelpOrHold;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @policeStation.
  ///
  /// In en, this message translates to:
  /// **'Police Station'**
  String get policeStation;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// No description provided for @fireStation.
  ///
  /// In en, this message translates to:
  /// **'Fire Station'**
  String get fireStation;

  /// No description provided for @ambulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get ambulance;

  /// No description provided for @nearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get nearby;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY'**
  String get emergency;

  /// No description provided for @emergencyConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will immediately call the national emergency hotline.\n\nAre you sure you need emergency help?'**
  String get emergencyConfirm;

  /// No description provided for @call119.
  ///
  /// In en, this message translates to:
  /// **'CALL 119'**
  String get call119;

  /// No description provided for @noServiceAvailable.
  ///
  /// In en, this message translates to:
  /// **'No {label} entries are available right now.'**
  String noServiceAvailable(String label);

  /// No description provided for @noPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'This service does not have a phone number yet.'**
  String get noPhoneNumber;

  /// No description provided for @unableToCall.
  ///
  /// In en, this message translates to:
  /// **'Unable to place the call right now.'**
  String get unableToCall;

  /// No description provided for @noGeneralContacts.
  ///
  /// In en, this message translates to:
  /// **'No general contacts have been saved yet.'**
  String get noGeneralContacts;

  /// No description provided for @noContactPhone.
  ///
  /// In en, this message translates to:
  /// **'The selected contact does not have a phone number.'**
  String get noContactPhone;

  /// No description provided for @unableToLoadContacts.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your saved contacts right now.'**
  String get unableToLoadContacts;

  /// No description provided for @searchContactsServices.
  ///
  /// In en, this message translates to:
  /// **'Search contacts, services...'**
  String get searchContactsServices;

  /// No description provided for @seekHelp.
  ///
  /// In en, this message translates to:
  /// **'Seek Help'**
  String get seekHelp;

  /// No description provided for @nearbyCount.
  ///
  /// In en, this message translates to:
  /// **'{n} nearby'**
  String nearbyCount(int n);

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY CONTACTS'**
  String get emergencyContacts;

  /// No description provided for @noResultsForQuery.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String noResultsForQuery(String query);

  /// No description provided for @noCategoryContacts.
  ///
  /// In en, this message translates to:
  /// **'No contacts in this category.'**
  String get noCategoryContacts;

  /// No description provided for @addContacts.
  ///
  /// In en, this message translates to:
  /// **'Add contacts'**
  String get addContacts;

  /// No description provided for @couldNotLoadContacts.
  ///
  /// In en, this message translates to:
  /// **'Could not load contacts'**
  String get couldNotLoadContacts;

  /// No description provided for @noLocationOnMap.
  ///
  /// In en, this message translates to:
  /// **'{name} has no location on map'**
  String noLocationOnMap(String name);

  /// No description provided for @notificationsEnabledFor.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled for {name}'**
  String notificationsEnabledFor(String name);

  /// No description provided for @callEmergency.
  ///
  /// In en, this message translates to:
  /// **'CALL EMERGENCY'**
  String get callEmergency;

  /// No description provided for @open24Hours.
  ///
  /// In en, this message translates to:
  /// **'OPEN 24 HOURS'**
  String get open24Hours;

  /// No description provided for @noServicesFoundWithin.
  ///
  /// In en, this message translates to:
  /// **'No services found within {km} km.'**
  String noServicesFoundWithin(int km);

  /// No description provided for @withinKm.
  ///
  /// In en, this message translates to:
  /// **'Within {km} km'**
  String withinKm(int km);

  /// No description provided for @foundCount.
  ///
  /// In en, this message translates to:
  /// **'{n} found'**
  String foundCount(int n);

  /// No description provided for @locationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Location updated'**
  String get locationUpdated;

  /// No description provided for @couldNotLoadNearby.
  ///
  /// In en, this message translates to:
  /// **'Could not load nearby services'**
  String get couldNotLoadNearby;

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No services found.'**
  String get noServicesFound;

  /// No description provided for @couldNotLoadServices.
  ///
  /// In en, this message translates to:
  /// **'Could not load services'**
  String get couldNotLoadServices;

  /// No description provided for @contactsLabel.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contactsLabel;

  /// No description provided for @policeLabel.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get policeLabel;

  /// No description provided for @fireLabel.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get fireLabel;

  /// No description provided for @otherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherLabel;

  /// No description provided for @notifyThisContact.
  ///
  /// In en, this message translates to:
  /// **'Notify this contact'**
  String get notifyThisContact;

  /// No description provided for @emergencyServices.
  ///
  /// In en, this message translates to:
  /// **'Emergency Services'**
  String get emergencyServices;

  /// No description provided for @servicesNearYou.
  ///
  /// In en, this message translates to:
  /// **'Services near your location'**
  String get servicesNearYou;

  /// No description provided for @requestAssistance.
  ///
  /// In en, this message translates to:
  /// **'Request immediate assistance'**
  String get requestAssistance;

  /// No description provided for @erAndTrauma.
  ///
  /// In en, this message translates to:
  /// **'Emergency rooms & trauma centers'**
  String get erAndTrauma;

  /// No description provided for @medicalAndParamedics.
  ///
  /// In en, this message translates to:
  /// **'Medical & paramedics'**
  String get medicalAndParamedics;

  /// No description provided for @fireAndRescue.
  ///
  /// In en, this message translates to:
  /// **'Fire & rescue emergencies'**
  String get fireAndRescue;

  /// No description provided for @personalEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Personal emergency contacts'**
  String get personalEmergencyContacts;

  /// No description provided for @generalContact.
  ///
  /// In en, this message translates to:
  /// **'General Contact'**
  String get generalContact;

  /// No description provided for @savedEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'{n} saved emergency contacts'**
  String savedEmergencyContacts(int n);

  /// No description provided for @searchContacts.
  ///
  /// In en, this message translates to:
  /// **'Search contacts'**
  String get searchContacts;

  /// No description provided for @noContactsFound.
  ///
  /// In en, this message translates to:
  /// **'No contacts found'**
  String get noContactsFound;

  /// No description provided for @noEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'No emergency contacts yet'**
  String get noEmergencyContacts;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different name, phone, or relationship.'**
  String get tryDifferentSearch;

  /// No description provided for @addFamilyOrTrusted.
  ///
  /// In en, this message translates to:
  /// **'Add family or trusted contacts you can reach quickly.'**
  String get addFamilyOrTrusted;

  /// No description provided for @contactAdded.
  ///
  /// In en, this message translates to:
  /// **'Contact added'**
  String get contactAdded;

  /// No description provided for @contactUpdated.
  ///
  /// In en, this message translates to:
  /// **'Contact updated'**
  String get contactUpdated;

  /// No description provided for @contactDeleted.
  ///
  /// In en, this message translates to:
  /// **'Contact deleted'**
  String get contactDeleted;

  /// No description provided for @deleteContact.
  ///
  /// In en, this message translates to:
  /// **'Delete contact'**
  String get deleteContact;

  /// No description provided for @removeFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from your emergency contacts?'**
  String removeFromContacts(String name);

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// No description provided for @relationshipRequired.
  ///
  /// In en, this message translates to:
  /// **'Relationship is required'**
  String get relationshipRequired;

  /// No description provided for @addContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContactTitle;

  /// No description provided for @editContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get editContactTitle;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @contactActions.
  ///
  /// In en, this message translates to:
  /// **'Contact actions'**
  String get contactActions;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileLabel;

  /// No description provided for @medicalInfo.
  ///
  /// In en, this message translates to:
  /// **'Medical Info'**
  String get medicalInfo;

  /// No description provided for @nearbySearchRadius.
  ///
  /// In en, this message translates to:
  /// **'Nearby Search Radius'**
  String get nearbySearchRadius;

  /// No description provided for @locationPermission.
  ///
  /// In en, this message translates to:
  /// **'Location Permission'**
  String get locationPermission;

  /// No description provided for @openAppSettingsNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Opening app settings is not supported on this platform.'**
  String get openAppSettingsNotSupported;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailAlerts.
  ///
  /// In en, this message translates to:
  /// **'Email Alerts'**
  String get emailAlerts;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteAccountWarning;

  /// No description provided for @typeToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type \"{name}\" to confirm'**
  String typeToConfirm(String name);

  /// No description provided for @failedToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get failedToDeleteAccount;

  /// No description provided for @medicalInformation.
  ///
  /// In en, this message translates to:
  /// **'Medical Information'**
  String get medicalInformation;

  /// No description provided for @editMedicalInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Medical Info'**
  String get editMedicalInfo;

  /// No description provided for @emergencyInfo.
  ///
  /// In en, this message translates to:
  /// **'Emergency Info'**
  String get emergencyInfo;

  /// No description provided for @emergencyInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'This helps emergency responders provide the right assistance quickly.'**
  String get emergencyInfoDesc;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get bloodType;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @medicalConditions.
  ///
  /// In en, this message translates to:
  /// **'Medical Conditions'**
  String get medicalConditions;

  /// No description provided for @knownAllergies.
  ///
  /// In en, this message translates to:
  /// **'Known allergies'**
  String get knownAllergies;

  /// No description provided for @allergiesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Penicillin, Peanuts, Latex'**
  String get allergiesHint;

  /// No description provided for @ongoingConditions.
  ///
  /// In en, this message translates to:
  /// **'Ongoing conditions'**
  String get ongoingConditions;

  /// No description provided for @conditionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Asthma, Diabetes, Heart condition'**
  String get conditionsHint;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @selectBloodType.
  ///
  /// In en, this message translates to:
  /// **'Please select your blood type'**
  String get selectBloodType;

  /// No description provided for @failedToSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile. Please try again.'**
  String get failedToSaveProfile;

  /// No description provided for @requiredIndicator.
  ///
  /// In en, this message translates to:
  /// **'*'**
  String get requiredIndicator;

  /// No description provided for @reportSent.
  ///
  /// In en, this message translates to:
  /// **'Report Sent'**
  String get reportSent;

  /// No description provided for @reportSentMessage.
  ///
  /// In en, this message translates to:
  /// **'Your emergency report has been submitted. Help is being notified.'**
  String get reportSentMessage;

  /// No description provided for @reporting.
  ///
  /// In en, this message translates to:
  /// **'Reporting: {label}'**
  String reporting(String label);

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @whatHappened.
  ///
  /// In en, this message translates to:
  /// **'What happened? (optional)'**
  String get whatHappened;

  /// No description provided for @detectingLocation.
  ///
  /// In en, this message translates to:
  /// **'Detecting your location...'**
  String get detectingLocation;

  /// No description provided for @locationDetected.
  ///
  /// In en, this message translates to:
  /// **'Location detected: {lat}, {lng}'**
  String locationDetected(double lat, double lng);

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable — please enable GPS'**
  String get locationUnavailable;

  /// No description provided for @sendEmergencyReport.
  ///
  /// In en, this message translates to:
  /// **'SEND EMERGENCY REPORT'**
  String get sendEmergencyReport;

  /// No description provided for @nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// No description provided for @phoneIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneIsRequired;

  /// No description provided for @failedToSendReport.
  ///
  /// In en, this message translates to:
  /// **'Failed to send report. Please try again.'**
  String get failedToSendReport;

  /// No description provided for @immediateActionRequired.
  ///
  /// In en, this message translates to:
  /// **'IMMEDIATE ACTION REQUIRED'**
  String get immediateActionRequired;

  /// No description provided for @immediateActionBody.
  ///
  /// In en, this message translates to:
  /// **'Select the condition below to start life-saving protocols. Call emergency services immediately if not already done.'**
  String get immediateActionBody;

  /// No description provided for @call119Now.
  ///
  /// In en, this message translates to:
  /// **'CALL 119 NOW'**
  String get call119Now;

  /// No description provided for @emergencyHotlineDesc.
  ///
  /// In en, this message translates to:
  /// **'Emergency hotline — immediate help'**
  String get emergencyHotlineDesc;

  /// No description provided for @callEmergency119.
  ///
  /// In en, this message translates to:
  /// **'Call emergency services 119 now'**
  String get callEmergency119;

  /// No description provided for @noConditionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No conditions available.'**
  String get noConditionsAvailable;

  /// No description provided for @failedToLoadConditions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String failedToLoadConditions(String error);

  /// No description provided for @stepN.
  ///
  /// In en, this message translates to:
  /// **'Step {n}'**
  String stepN(int n);

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'BACK'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get next;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepOf(int current, int total);

  /// No description provided for @goToPrevStep.
  ///
  /// In en, this message translates to:
  /// **'Go to previous step'**
  String get goToPrevStep;

  /// No description provided for @goToNextStep.
  ///
  /// In en, this message translates to:
  /// **'Go to next step'**
  String get goToNextStep;

  /// No description provided for @sosCambodia.
  ///
  /// In en, this message translates to:
  /// **'SOS CAMBODIA'**
  String get sosCambodia;

  /// No description provided for @goBackToSosHome.
  ///
  /// In en, this message translates to:
  /// **'Go back to SOS Cambodia home'**
  String get goBackToSosHome;

  /// No description provided for @crucialWarning.
  ///
  /// In en, this message translates to:
  /// **'CRUCIAL WARNING'**
  String get crucialWarning;

  /// No description provided for @startSteps.
  ///
  /// In en, this message translates to:
  /// **'START STEPS'**
  String get startSteps;

  /// No description provided for @topicNotFound.
  ///
  /// In en, this message translates to:
  /// **'Topic not found'**
  String get topicNotFound;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get noNotificationsYet;

  /// No description provided for @servicePolice.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get servicePolice;

  /// No description provided for @serviceHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get serviceHospital;

  /// No description provided for @serviceFireStation.
  ///
  /// In en, this message translates to:
  /// **'Fire Station'**
  String get serviceFireStation;

  /// No description provided for @serviceAmbulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get serviceAmbulance;

  /// No description provided for @serviceHelpline.
  ///
  /// In en, this message translates to:
  /// **'Helpline'**
  String get serviceHelpline;

  /// No description provided for @serviceDisasterResponse.
  ///
  /// In en, this message translates to:
  /// **'Disaster Response'**
  String get serviceDisasterResponse;

  /// No description provided for @serviceNearbyPlaces.
  ///
  /// In en, this message translates to:
  /// **'Nearby Places'**
  String get serviceNearbyPlaces;

  /// No description provided for @serviceGeneralContact.
  ///
  /// In en, this message translates to:
  /// **'General Contact'**
  String get serviceGeneralContact;

  /// No description provided for @servicePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get servicePlaceholder;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'ResQ-KH Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: June 2026'**
  String get privacyLastUpdated;

  /// No description provided for @privacySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Body.
  ///
  /// In en, this message translates to:
  /// **'ResQ-KH is an accessibility-first emergency assistance application developed as a university project. Your privacy is important to us. This policy explains how your information is collected and used while using the application.'**
  String get privacySection1Body;

  /// No description provided for @privacySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Information We Collect'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Body.
  ///
  /// In en, this message translates to:
  /// **'We may collect:\n\n• Full Name\n• Phone Number\n• Email Address (optional)\n• Current Location (only when permission is granted)\n• Emergency Reports submitted through the application\n• App preferences such as language and theme.'**
  String get privacySection2Body;

  /// No description provided for @privacySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Why We Collect Your Information'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Body.
  ///
  /// In en, this message translates to:
  /// **'Your information is collected only to:\n\n• Create your account\n• Verify your identity using OTP\n• Submit emergency reports\n• Help emergency responders locate incidents\n• Improve the overall user experience.'**
  String get privacySection3Body;

  /// No description provided for @privacySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Location Permission'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Body.
  ///
  /// In en, this message translates to:
  /// **'Your location is only accessed after your permission has been granted. The location is used solely to assist emergency reporting and nearby emergency service recommendations.'**
  String get privacySection4Body;

  /// No description provided for @privacySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Data Sharing'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Body.
  ///
  /// In en, this message translates to:
  /// **'Emergency reports may be shared with emergency service providers such as hospitals, police stations, fire departments, or ambulance services for demonstration purposes within this academic project. We do not sell or share your personal information with third-party advertisers.'**
  String get privacySection5Body;

  /// No description provided for @privacySection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Data Security'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Body.
  ///
  /// In en, this message translates to:
  /// **'We take reasonable measures to protect your information. However, as this application is developed for educational purposes, absolute security cannot be guaranteed.'**
  String get privacySection6Body;

  /// No description provided for @privacySection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Your Rights'**
  String get privacySection7Title;

  /// No description provided for @privacySection7Body.
  ///
  /// In en, this message translates to:
  /// **'You may:\n\n• Update your personal information.\n• Request deletion of your account.\n• Withdraw location permission at any time through your device settings.'**
  String get privacySection7Body;

  /// No description provided for @privacySection8Title.
  ///
  /// In en, this message translates to:
  /// **'8. Changes to this Policy'**
  String get privacySection8Title;

  /// No description provided for @privacySection8Body.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy may be updated from time to time. Any significant changes will be reflected within the application.'**
  String get privacySection8Body;

  /// No description provided for @privacySection9Title.
  ///
  /// In en, this message translates to:
  /// **'9. Contact'**
  String get privacySection9Title;

  /// No description provided for @privacySection9Body.
  ///
  /// In en, this message translates to:
  /// **'If you have questions regarding this Privacy Policy, please contact the ResQ-KH development team.\n\nEmail: support@resq-kh.local'**
  String get privacySection9Body;

  /// No description provided for @privacyCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 ResQ-KH'**
  String get privacyCopyright;

  /// No description provided for @resq.
  ///
  /// In en, this message translates to:
  /// **'RESQ'**
  String get resq;

  /// No description provided for @emergencyResponseSystem.
  ///
  /// In en, this message translates to:
  /// **'Emergency Response System'**
  String get emergencyResponseSystem;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @selectEmergencyType.
  ///
  /// In en, this message translates to:
  /// **'Select Emergency Type'**
  String get selectEmergencyType;

  /// No description provided for @whatKindOfHelp.
  ///
  /// In en, this message translates to:
  /// **'What kind of help do you need?'**
  String get whatKindOfHelp;

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{km} km away'**
  String kmAway(double km);

  /// No description provided for @sosEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get sosEmergency;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @themeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get themeAuto;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @incidentFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get incidentFire;

  /// No description provided for @incidentCarCrash.
  ///
  /// In en, this message translates to:
  /// **'Car Crash'**
  String get incidentCarCrash;

  /// No description provided for @incidentMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical Emergency'**
  String get incidentMedical;

  /// No description provided for @incidentPolice.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get incidentPolice;

  /// No description provided for @incidentWater.
  ///
  /// In en, this message translates to:
  /// **'Flood / Water'**
  String get incidentWater;

  /// No description provided for @incidentStorm.
  ///
  /// In en, this message translates to:
  /// **'Storm'**
  String get incidentStorm;

  /// No description provided for @incidentShield.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get incidentShield;

  /// No description provided for @incidentBolt.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get incidentBolt;

  /// No description provided for @incidentUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get incidentUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
