// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NetworkChecker';

  @override
  String get common_signIn => 'Sign In';

  @override
  String get common_signUp => 'Sign Up';

  @override
  String get common_email => 'Email address';

  @override
  String get common_password => 'Password';

  @override
  String get common_fillAllFields => 'Please fill in all fields';

  @override
  String get common_back => 'Back';

  @override
  String get login_title => 'Welcome back';

  @override
  String get login_subtitle => 'Sign in to access your network diagnostics';

  @override
  String get login_loginButton => 'Sign In';

  @override
  String get login_noAccount => 'Don\'t have an account?';

  @override
  String get login_createAccount => 'Create account';

  @override
  String get login_invalidCredentials => 'Invalid email or password';

  @override
  String get login_genericError => 'Something went wrong. Please try again.';

  @override
  String get register_title => 'Create your account';

  @override
  String get register_subtitle =>
      'Start measuring and saving your network diagnostics';

  @override
  String get register_confirmPassword => 'Confirm password';

  @override
  String get register_registerButton => 'Create account';

  @override
  String get register_hasAccount => 'Already have an account?';

  @override
  String get register_signIn => 'Sign In';

  @override
  String get register_passwordsMismatch => 'Passwords do not match';

  @override
  String get register_invalidEmail => 'Enter a valid email address';

  @override
  String get register_weakPassword => 'Password must be at least 6 characters';

  @override
  String get register_accountExists =>
      'An account already exists with this email';

  @override
  String get register_success => 'Account created successfully';

  @override
  String get onboarding_skip => 'Skip';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_done => 'Get Started';

  @override
  String get onboarding_p1_title => 'Connection detection';

  @override
  String get onboarding_p1_desc =>
      'NetworkChecker automatically detects your connection type — Wi-Fi, mobile data or no network — and confirms real internet access.';

  @override
  String get onboarding_p1_icon => 'wifi';

  @override
  String get onboarding_p2_title => 'Quality analysis';

  @override
  String get onboarding_p2_desc =>
      'Measure your connection quality: latency (response time), signal strength, IP address and the name of the connected Wi-Fi network.';

  @override
  String get onboarding_p2_icon => 'speed';

  @override
  String get onboarding_p3_title => 'Continuous monitoring';

  @override
  String get onboarding_p3_desc =>
      'Your connection is monitored automatically every 15 seconds. Launch a manual diagnostic at any time to check your network right now.';

  @override
  String get onboarding_p3_icon => 'monitor';

  @override
  String get onboarding_p4_title => 'History & export';

  @override
  String get onboarding_p4_desc =>
      'Every diagnostic is safely stored in the cloud (Firebase) and kept per account. Export your history as a JSON file to share or analyse it.';

  @override
  String get onboarding_p4_icon => 'archive';

  @override
  String get home_runTest => 'Run a test';

  @override
  String get home_testing => 'Testing...';

  @override
  String get home_testSaved => 'Diagnostic saved';

  @override
  String get home_error => 'Error';

  @override
  String get home_signOut => 'Sign out';

  @override
  String get home_signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String home_liveMonitoring(Object seconds) {
    return 'Live monitoring • ${seconds}s';
  }

  @override
  String get home_connected => 'Connected to internet';

  @override
  String get home_disconnected => 'No internet access';

  @override
  String get home_noReport =>
      'No diagnostic yet. Run a test to see your network status.';

  @override
  String get home_section_metrics => 'Network metrics';

  @override
  String get home_section_metrics_desc =>
      'Tap a card to learn what each metric means.';

  @override
  String get home_metric_latency => 'Latency';

  @override
  String get home_metric_latency_desc =>
      'Round-trip response time to a remote server, in milliseconds. Lower is better.';

  @override
  String get home_metric_signal => 'Signal strength';

  @override
  String get home_metric_signal_desc =>
      'Quality of your Wi-Fi signal, in dBm. Values closer to 0 indicate a stronger signal.';

  @override
  String get home_metric_ip => 'IP address';

  @override
  String get home_metric_ip_desc =>
      'The local address assigned to your device on the current network.';

  @override
  String get home_metric_ssid => 'Network (SSID)';

  @override
  String get home_metric_ssid_desc =>
      'The name of the Wi-Fi network you are connected to.';

  @override
  String get home_metric_battery => 'Battery';

  @override
  String get home_metric_battery_desc =>
      'Current battery level of your device, in percentage.';

  @override
  String get home_notAvailable => 'Not available';

  @override
  String home_milliseconds(Object ms) {
    return '$ms ms';
  }

  @override
  String get history_title => 'History';

  @override
  String get history_empty => 'No diagnostics saved yet';

  @override
  String get history_clearAll => 'Delete all';

  @override
  String get history_clearAllConfirmTitle => 'Clear the whole history?';

  @override
  String history_clearAllConfirmBody(Object count) {
    return 'The $count saved reports will be permanently deleted. This action cannot be undone.';
  }

  @override
  String get history_delete => 'Delete';

  @override
  String get history_deleted => 'Report deleted';

  @override
  String get history_cleared => 'History cleared';

  @override
  String get history_export => 'Export';

  @override
  String get history_exporting => 'Exporting...';

  @override
  String get history_exportReady => 'JSON export ready to share';

  @override
  String get history_exportError => 'Export error';

  @override
  String get history_deleteConfirmTitle => 'Delete this report?';

  @override
  String history_deleteConfirmBody(Object date) {
    return 'The report from $date will be permanently deleted.';
  }

  @override
  String get history_cancel => 'Cancel';

  @override
  String get details_connected => 'Connected to internet';

  @override
  String get details_disconnected => 'No internet access';

  @override
  String get details_general => 'General information';

  @override
  String get details_technical => 'Technical details';

  @override
  String get details_date => 'Diagnostic date';

  @override
  String get details_latency => 'Latency';

  @override
  String get details_battery => 'Battery';

  @override
  String get details_signal => 'Signal strength';

  @override
  String get details_ip => 'IP address';

  @override
  String get details_ssid => 'Network (SSID)';

  @override
  String get details_notAvailable => 'Not available';

  @override
  String details_milliseconds(Object ms) {
    return '$ms ms';
  }

  @override
  String get how_title => 'How it works';

  @override
  String get how_subtitle =>
      'Understand what NetworkChecker measures and how your data is handled.';

  @override
  String get how_architectureTitle => 'Three-layer architecture';

  @override
  String get how_architectureBody =>
      'Native code collects the network data, Flutter processes and displays it, and Firebase stores your history securely.';

  @override
  String get how_nativeTitle => '1 · Native layer';

  @override
  String get how_nativeBody =>
      'On Android and iOS, a Platform Channel reads the connection type, signal strength, IP address, network name and battery level directly from the device.';

  @override
  String get how_flutterTitle => '2 · Flutter processing';

  @override
  String get how_flutterBody =>
      'The NetworkService turns the raw native data into a typed report. The NetworkProvider keeps the UI in sync and polls a new diagnostic every 15 seconds.';

  @override
  String get how_firebaseTitle => '3 · Firebase storage';

  @override
  String get how_firebaseBody =>
      'Each report is saved in Firestore inside its own per-user collection, protected by Firebase Auth rules so only you can read your own history.';

  @override
  String get how_exportTitle => 'JSON export';

  @override
  String get how_exportBody =>
      'From the History screen you can export all your reports as a JSON file and share it with any app on your device.';
}
