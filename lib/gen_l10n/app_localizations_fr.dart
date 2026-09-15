// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'NetworkChecker';

  @override
  String get common_signIn => 'Se connecter';

  @override
  String get common_signUp => 'S\'inscrire';

  @override
  String get common_email => 'Adresse email';

  @override
  String get common_password => 'Mot de passe';

  @override
  String get common_fillAllFields => 'Veuillez remplir tous les champs';

  @override
  String get common_back => 'Retour';

  @override
  String get login_title => 'Bon retour';

  @override
  String get login_subtitle =>
      'Connectez-vous pour accéder à vos diagnostics réseau';

  @override
  String get login_loginButton => 'Se connecter';

  @override
  String get login_noAccount => 'Pas encore de compte ?';

  @override
  String get login_createAccount => 'Créer un compte';

  @override
  String get login_invalidCredentials => 'Email ou mot de passe incorrect';

  @override
  String get login_genericError =>
      'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get register_title => 'Créer votre compte';

  @override
  String get register_subtitle =>
      'Commencez à mesurer et sauvegarder vos diagnostics réseau';

  @override
  String get register_confirmPassword => 'Confirmer le mot de passe';

  @override
  String get register_registerButton => 'Créer mon compte';

  @override
  String get register_hasAccount => 'Déjà un compte ?';

  @override
  String get register_signIn => 'Se connecter';

  @override
  String get register_passwordsMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get register_invalidEmail => 'Saisissez une adresse email valide';

  @override
  String get register_weakPassword =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get register_accountExists => 'Un compte existe déjà avec cet email';

  @override
  String get register_success => 'Compte créé avec succès';

  @override
  String get onboarding_skip => 'Passer';

  @override
  String get onboarding_next => 'Suivant';

  @override
  String get onboarding_done => 'Commencer';

  @override
  String get onboarding_p1_title => 'Détection de connexion';

  @override
  String get onboarding_p1_desc =>
      'NetworkChecker détecte automatiquement votre type de connexion — Wi-Fi, données mobiles ou aucun réseau — et confirme l\'accès réel à internet.';

  @override
  String get onboarding_p1_icon => 'wifi';

  @override
  String get onboarding_p2_title => 'Analyse de qualité';

  @override
  String get onboarding_p2_desc =>
      'Mesurez la qualité de votre connexion : latence (temps de réponse), force du signal, adresse IP et nom du réseau Wi-Fi connecté.';

  @override
  String get onboarding_p2_icon => 'speed';

  @override
  String get onboarding_p3_title => 'Suivi continu';

  @override
  String get onboarding_p3_desc =>
      'Votre connexion est surveillée automatiquement toutes les 15 secondes. Lancez un diagnostic manuel à tout moment pour vérifier votre réseau.';

  @override
  String get onboarding_p3_icon => 'monitor';

  @override
  String get onboarding_p4_title => 'Historique & export';

  @override
  String get onboarding_p4_desc =>
      'Chaque diagnostic est stocké en toute sécurité dans le cloud (Firebase) et conservé par compte. Exportez votre historique en JSON pour le partager ou l\'analyser.';

  @override
  String get onboarding_p4_icon => 'archive';

  @override
  String get home_runTest => 'Lancer un test';

  @override
  String get home_testing => 'Test en cours...';

  @override
  String get home_testSaved => 'Diagnostic enregistré';

  @override
  String get home_error => 'Erreur';

  @override
  String get home_signOut => 'Se déconnecter';

  @override
  String get home_signOutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String home_liveMonitoring(Object seconds) {
    return 'Surveillance en continu • ${seconds}s';
  }

  @override
  String get home_connected => 'Connecté à internet';

  @override
  String get home_disconnected => 'Pas d\'accès internet';

  @override
  String get home_noReport =>
      'Aucun diagnostic pour l\'instant. Lancez un test pour voir votre état réseau.';

  @override
  String get home_section_metrics => 'Métriques réseau';

  @override
  String get home_section_metrics_desc =>
      'Appuyez sur une carte pour comprendre chaque mesure.';

  @override
  String get home_metric_latency => 'Latence';

  @override
  String get home_metric_latency_desc =>
      'Temps de réponse aller-retour vers un serveur distant, en millisecondes. Plus c\'est bas, mieux c\'est.';

  @override
  String get home_metric_signal => 'Force du signal';

  @override
  String get home_metric_signal_desc =>
      'Qualité de votre signal Wi-Fi, en dBm. Une valeur proche de 0 indique un signal plus fort.';

  @override
  String get home_metric_ip => 'Adresse IP';

  @override
  String get home_metric_ip_desc =>
      'L\'adresse locale attribuée à votre appareil sur le réseau actuel.';

  @override
  String get home_metric_ssid => 'Réseau (SSID)';

  @override
  String get home_metric_ssid_desc =>
      'Le nom du réseau Wi-Fi auquel vous êtes connecté.';

  @override
  String get home_metric_battery => 'Batterie';

  @override
  String get home_metric_battery_desc =>
      'Niveau de batterie actuel de votre appareil, en pourcentage.';

  @override
  String get home_notAvailable => 'Non disponible';

  @override
  String home_milliseconds(Object ms) {
    return '$ms ms';
  }

  @override
  String get history_title => 'Historique';

  @override
  String get history_empty => 'Aucun diagnostic enregistré';

  @override
  String get history_clearAll => 'Tout supprimer';

  @override
  String get history_clearAllConfirmTitle => 'Vider tout l\'historique ?';

  @override
  String history_clearAllConfirmBody(Object count) {
    return 'Les $count rapports enregistrés seront supprimés définitivement. Cette action est irréversible.';
  }

  @override
  String get history_delete => 'Supprimer';

  @override
  String get history_deleted => 'Rapport supprimé';

  @override
  String get history_cleared => 'Historique vidé';

  @override
  String get history_export => 'Exporter';

  @override
  String get history_exporting => 'Export...';

  @override
  String get history_exportReady => 'Export JSON prêt à partager';

  @override
  String get history_exportError => 'Erreur d\'export';

  @override
  String get history_deleteConfirmTitle => 'Supprimer ce diagnostic ?';

  @override
  String history_deleteConfirmBody(Object date) {
    return 'Le rapport du $date sera supprimé définitivement.';
  }

  @override
  String get history_cancel => 'Annuler';

  @override
  String get details_connected => 'Connecté à internet';

  @override
  String get details_disconnected => 'Pas d\'accès internet';

  @override
  String get details_general => 'Informations générales';

  @override
  String get details_technical => 'Détails techniques';

  @override
  String get details_date => 'Date du diagnostic';

  @override
  String get details_latency => 'Latence';

  @override
  String get details_battery => 'Batterie';

  @override
  String get details_signal => 'Force du signal';

  @override
  String get details_ip => 'Adresse IP';

  @override
  String get details_ssid => 'Réseau (SSID)';

  @override
  String get details_notAvailable => 'Non disponible';

  @override
  String details_milliseconds(Object ms) {
    return '$ms ms';
  }

  @override
  String get how_title => 'Comment ça marche';

  @override
  String get how_subtitle =>
      'Comprenez ce que mesure NetworkChecker et comment vos données sont traitées.';

  @override
  String get how_architectureTitle => 'Architecture en trois couches';

  @override
  String get how_architectureBody =>
      'Le code natif collecte les données réseau, Flutter les traite et les affiche, et Firebase stocke votre historique en toute sécurité.';

  @override
  String get how_nativeTitle => '1 · Couche native';

  @override
  String get how_nativeBody =>
      'Sur Android et iOS, un Platform Channel lit directement sur l\'appareil : type de connexion, force du signal, adresse IP, nom du réseau et niveau de batterie.';

  @override
  String get how_flutterTitle => '2 · Traitement Flutter';

  @override
  String get how_flutterBody =>
      'Le NetworkService transforme les données natives brutes en rapport typé. Le NetworkProvider garde l\'interface synchronisée et lance un nouveau diagnostic toutes les 15 secondes.';

  @override
  String get how_firebaseTitle => '3 · Stockage Firebase';

  @override
  String get how_firebaseBody =>
      'Chaque rapport est sauvegardé dans Firestore dans sa propre collection par utilisateur, protégé par les règles Firebase Auth pour que vous seul puissiez lire votre historique.';

  @override
  String get how_exportTitle => 'Export JSON';

  @override
  String get how_exportBody =>
      'Depuis l\'écran Historique, exportez tous vos rapports en fichier JSON et partagez-les avec n\'importe quelle application de votre appareil.';
}
