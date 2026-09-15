import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
    Locale('fr'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'NetworkChecker'**
  String get appTitle;

  /// No description provided for @common_signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get common_signIn;

  /// No description provided for @common_signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get common_signUp;

  /// No description provided for @common_email.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get common_email;

  /// No description provided for @common_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get common_password;

  /// No description provided for @common_fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get common_fillAllFields;

  /// No description provided for @common_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_back;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get login_title;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your network diagnostics'**
  String get login_subtitle;

  /// No description provided for @login_loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login_loginButton;

  /// No description provided for @login_noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get login_noAccount;

  /// No description provided for @login_createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get login_createAccount;

  /// No description provided for @login_invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get login_invalidCredentials;

  /// No description provided for @login_genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get login_genericError;

  /// No description provided for @register_title.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get register_title;

  /// No description provided for @register_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start measuring and saving your network diagnostics'**
  String get register_subtitle;

  /// No description provided for @register_confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get register_confirmPassword;

  /// No description provided for @register_registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get register_registerButton;

  /// No description provided for @register_hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get register_hasAccount;

  /// No description provided for @register_signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get register_signIn;

  /// No description provided for @register_passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get register_passwordsMismatch;

  /// No description provided for @register_invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get register_invalidEmail;

  /// No description provided for @register_weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get register_weakPassword;

  /// No description provided for @register_accountExists.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email'**
  String get register_accountExists;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get register_success;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @onboarding_done.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_done;

  /// No description provided for @onboarding_p1_title.
  ///
  /// In en, this message translates to:
  /// **'Connection detection'**
  String get onboarding_p1_title;

  /// No description provided for @onboarding_p1_desc.
  ///
  /// In en, this message translates to:
  /// **'NetworkChecker automatically detects your connection type — Wi-Fi, mobile data or no network — and confirms real internet access.'**
  String get onboarding_p1_desc;

  /// No description provided for @onboarding_p1_icon.
  ///
  /// In en, this message translates to:
  /// **'wifi'**
  String get onboarding_p1_icon;

  /// No description provided for @onboarding_p2_title.
  ///
  /// In en, this message translates to:
  /// **'Quality analysis'**
  String get onboarding_p2_title;

  /// No description provided for @onboarding_p2_desc.
  ///
  /// In en, this message translates to:
  /// **'Measure your connection quality: latency (response time), signal strength, IP address and the name of the connected Wi-Fi network.'**
  String get onboarding_p2_desc;

  /// No description provided for @onboarding_p2_icon.
  ///
  /// In en, this message translates to:
  /// **'speed'**
  String get onboarding_p2_icon;

  /// No description provided for @onboarding_p3_title.
  ///
  /// In en, this message translates to:
  /// **'Continuous monitoring'**
  String get onboarding_p3_title;

  /// No description provided for @onboarding_p3_desc.
  ///
  /// In en, this message translates to:
  /// **'Your connection is monitored automatically every 15 seconds. Launch a manual diagnostic at any time to check your network right now.'**
  String get onboarding_p3_desc;

  /// No description provided for @onboarding_p3_icon.
  ///
  /// In en, this message translates to:
  /// **'monitor'**
  String get onboarding_p3_icon;

  /// No description provided for @onboarding_p4_title.
  ///
  /// In en, this message translates to:
  /// **'History & export'**
  String get onboarding_p4_title;

  /// No description provided for @onboarding_p4_desc.
  ///
  /// In en, this message translates to:
  /// **'Every diagnostic is safely stored in the cloud (Firebase) and kept per account. Export your history as a JSON file to share or analyse it.'**
  String get onboarding_p4_desc;

  /// No description provided for @onboarding_p4_icon.
  ///
  /// In en, this message translates to:
  /// **'archive'**
  String get onboarding_p4_icon;

  /// No description provided for @home_runTest.
  ///
  /// In en, this message translates to:
  /// **'Run a test'**
  String get home_runTest;

  /// No description provided for @home_testing.
  ///
  /// In en, this message translates to:
  /// **'Testing...'**
  String get home_testing;

  /// No description provided for @home_testSaved.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic saved'**
  String get home_testSaved;

  /// No description provided for @home_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get home_error;

  /// No description provided for @home_signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get home_signOut;

  /// No description provided for @home_signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get home_signOutConfirm;

  /// No description provided for @home_liveMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Live monitoring • {seconds}s'**
  String home_liveMonitoring(Object seconds);

  /// No description provided for @home_connected.
  ///
  /// In en, this message translates to:
  /// **'Connected to internet'**
  String get home_connected;

  /// No description provided for @home_disconnected.
  ///
  /// In en, this message translates to:
  /// **'No internet access'**
  String get home_disconnected;

  /// No description provided for @home_noReport.
  ///
  /// In en, this message translates to:
  /// **'No diagnostic yet. Run a test to see your network status.'**
  String get home_noReport;

  /// No description provided for @home_section_metrics.
  ///
  /// In en, this message translates to:
  /// **'Network metrics'**
  String get home_section_metrics;

  /// No description provided for @home_section_metrics_desc.
  ///
  /// In en, this message translates to:
  /// **'Tap a card to learn what each metric means.'**
  String get home_section_metrics_desc;

  /// No description provided for @home_metric_latency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get home_metric_latency;

  /// No description provided for @home_metric_latency_desc.
  ///
  /// In en, this message translates to:
  /// **'Round-trip response time to a remote server, in milliseconds. Lower is better.'**
  String get home_metric_latency_desc;

  /// No description provided for @home_metric_signal.
  ///
  /// In en, this message translates to:
  /// **'Signal strength'**
  String get home_metric_signal;

  /// No description provided for @home_metric_signal_desc.
  ///
  /// In en, this message translates to:
  /// **'Quality of your Wi-Fi signal, in dBm. Values closer to 0 indicate a stronger signal.'**
  String get home_metric_signal_desc;

  /// No description provided for @home_metric_ip.
  ///
  /// In en, this message translates to:
  /// **'IP address'**
  String get home_metric_ip;

  /// No description provided for @home_metric_ip_desc.
  ///
  /// In en, this message translates to:
  /// **'The local address assigned to your device on the current network.'**
  String get home_metric_ip_desc;

  /// No description provided for @home_metric_ssid.
  ///
  /// In en, this message translates to:
  /// **'Network (SSID)'**
  String get home_metric_ssid;

  /// No description provided for @home_metric_ssid_desc.
  ///
  /// In en, this message translates to:
  /// **'The name of the Wi-Fi network you are connected to.'**
  String get home_metric_ssid_desc;

  /// No description provided for @home_metric_battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get home_metric_battery;

  /// No description provided for @home_metric_battery_desc.
  ///
  /// In en, this message translates to:
  /// **'Current battery level of your device, in percentage.'**
  String get home_metric_battery_desc;

  /// No description provided for @home_notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get home_notAvailable;

  /// No description provided for @home_milliseconds.
  ///
  /// In en, this message translates to:
  /// **'{ms} ms'**
  String home_milliseconds(Object ms);

  /// No description provided for @history_title.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history_title;

  /// No description provided for @history_empty.
  ///
  /// In en, this message translates to:
  /// **'No diagnostics saved yet'**
  String get history_empty;

  /// No description provided for @history_clearAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get history_clearAll;

  /// No description provided for @history_clearAllConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear the whole history?'**
  String get history_clearAllConfirmTitle;

  /// No description provided for @history_clearAllConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The {count} saved reports will be permanently deleted. This action cannot be undone.'**
  String history_clearAllConfirmBody(Object count);

  /// No description provided for @history_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get history_delete;

  /// No description provided for @history_deleted.
  ///
  /// In en, this message translates to:
  /// **'Report deleted'**
  String get history_deleted;

  /// No description provided for @history_cleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get history_cleared;

  /// No description provided for @history_export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get history_export;

  /// No description provided for @history_exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get history_exporting;

  /// No description provided for @history_exportReady.
  ///
  /// In en, this message translates to:
  /// **'JSON export ready to share'**
  String get history_exportReady;

  /// No description provided for @history_exportError.
  ///
  /// In en, this message translates to:
  /// **'Export error'**
  String get history_exportError;

  /// No description provided for @history_deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this report?'**
  String get history_deleteConfirmTitle;

  /// No description provided for @history_deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The report from {date} will be permanently deleted.'**
  String history_deleteConfirmBody(Object date);

  /// No description provided for @history_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get history_cancel;

  /// No description provided for @details_connected.
  ///
  /// In en, this message translates to:
  /// **'Connected to internet'**
  String get details_connected;

  /// No description provided for @details_disconnected.
  ///
  /// In en, this message translates to:
  /// **'No internet access'**
  String get details_disconnected;

  /// No description provided for @details_general.
  ///
  /// In en, this message translates to:
  /// **'General information'**
  String get details_general;

  /// No description provided for @details_technical.
  ///
  /// In en, this message translates to:
  /// **'Technical details'**
  String get details_technical;

  /// No description provided for @details_date.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic date'**
  String get details_date;

  /// No description provided for @details_latency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get details_latency;

  /// No description provided for @details_battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get details_battery;

  /// No description provided for @details_signal.
  ///
  /// In en, this message translates to:
  /// **'Signal strength'**
  String get details_signal;

  /// No description provided for @details_ip.
  ///
  /// In en, this message translates to:
  /// **'IP address'**
  String get details_ip;

  /// No description provided for @details_ssid.
  ///
  /// In en, this message translates to:
  /// **'Network (SSID)'**
  String get details_ssid;

  /// No description provided for @details_notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get details_notAvailable;

  /// No description provided for @details_milliseconds.
  ///
  /// In en, this message translates to:
  /// **'{ms} ms'**
  String details_milliseconds(Object ms);

  /// No description provided for @how_title.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get how_title;

  /// No description provided for @how_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Understand what NetworkChecker measures and how your data is handled.'**
  String get how_subtitle;

  /// No description provided for @how_architectureTitle.
  ///
  /// In en, this message translates to:
  /// **'Three-layer architecture'**
  String get how_architectureTitle;

  /// No description provided for @how_architectureBody.
  ///
  /// In en, this message translates to:
  /// **'Native code collects the network data, Flutter processes and displays it, and Firebase stores your history securely.'**
  String get how_architectureBody;

  /// No description provided for @how_nativeTitle.
  ///
  /// In en, this message translates to:
  /// **'1 · Native layer'**
  String get how_nativeTitle;

  /// No description provided for @how_nativeBody.
  ///
  /// In en, this message translates to:
  /// **'On Android and iOS, a Platform Channel reads the connection type, signal strength, IP address, network name and battery level directly from the device.'**
  String get how_nativeBody;

  /// No description provided for @how_flutterTitle.
  ///
  /// In en, this message translates to:
  /// **'2 · Flutter processing'**
  String get how_flutterTitle;

  /// No description provided for @how_flutterBody.
  ///
  /// In en, this message translates to:
  /// **'The NetworkService turns the raw native data into a typed report. The NetworkProvider keeps the UI in sync and polls a new diagnostic every 15 seconds.'**
  String get how_flutterBody;

  /// No description provided for @how_firebaseTitle.
  ///
  /// In en, this message translates to:
  /// **'3 · Firebase storage'**
  String get how_firebaseTitle;

  /// No description provided for @how_firebaseBody.
  ///
  /// In en, this message translates to:
  /// **'Each report is saved in Firestore inside its own per-user collection, protected by Firebase Auth rules so only you can read your own history.'**
  String get how_firebaseBody;

  /// No description provided for @how_exportTitle.
  ///
  /// In en, this message translates to:
  /// **'JSON export'**
  String get how_exportTitle;

  /// No description provided for @how_exportBody.
  ///
  /// In en, this message translates to:
  /// **'From the History screen you can export all your reports as a JSON file and share it with any app on your device.'**
  String get how_exportBody;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
