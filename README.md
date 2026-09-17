#  NetworkChecker

**Diagnostic de connectivité réseau** — Application Flutter combinant code natif (Platform Channels), gestion d'état, et Firebase.

Projet réalisé dans le cadre du **Mini-Hackathon FFSC 2026**.

NetworkChecker permet de diagnostiquer l'état de la connexion réseau d'un appareil mobile : type de connexion, accès internet réel (pas seulement déclaré par le système), détails techniques (signal, IP, SSID), et niveau de batterie. Chaque diagnostic est enregistré dans un historique personnel, exportable en JSON et partageable.

L'application illustre trois exigences techniques principales :



 **Platform Channels** : Code natif Android (Kotlin) et iOS (Swift) exposé à Flutter via `MethodChannel` 
 **State Management** : `ChangeNotifier` natif de Flutter, sans package externe 
 **Firebase**  Authentication (anonyme + email/mot de passe) et Cloud Firestore 
 **Bonus**  Récupération du pourcentage de batterie de l'appareil 


## Fonctionnalités

### Cœur du projet
-  Détection du type de connexion (Wifi / données mobiles / aucune)
-  Vérification **réelle** de l'accès internet (requête HTTP, pas seulement l'état déclaré par le système)
-  Affichage du statut réseau en temps réel (polling automatique + test manuel)
-  Détails techniques : force du signal, adresse IP, SSID (Wifi), niveau de batterie
-  Historique des diagnostics (Firestore), avec suppression individuelle ou totale
-  Authentification (connexion anonyme automatique **ou** création de compte email/mot de passe)

### Bonus et extras
-  Export des rapports en fichier `.json`, avec partage natif (`share_plus`)
-  Pourcentage de batterie de l'appareil (Android et iOS)
-  Onboarding au premier lancement
-  Support multilingue (`AppLocalizations`)
-  Thème clair/sombre automatique, basé sur les réglages système


## Stack technique

- **Framework** : Flutter / Dart
- **State management** : `ChangeNotifier` + `ListenableBuilder` (aucun package externe)
- **Backend** : Firebase (Authentication, Cloud Firestore)
- **Natif** : Kotlin (Android), Swift (iOS)
- **Packages clés** : `firebase_core`, `firebase_auth`, `cloud_firestore`, `share_plus`, `path_provider`, `shared_preferences`



## Architecture

### Vue d'ensemble

Le projet suit une architecture en couches, proche d'un **MVVM allégé** : chaque couche a une responsabilité unique et ne dépend que de la couche immédiatement inférieure.


### Flux de données

Le parcours complet d'un diagnostic réseau :

1. **Natif** (`MainActivity.kt` / `AppDelegate.swift`) lit les informations système réelles : `ConnectivityManager`, `WifiManager`, `TelephonyManager`, `BatteryManager` (Android) ou `NWPathMonitor` (iOS).
2. **`platform/network_channel.dart`** appelle ce code natif via un `MethodChannel` nommé `com.networkchecker/network` et reçoit une `Map` brute.
3. **`services/network_service.dart`** transforme cette map en objet typé `NetworkReport`, et effectue une **vraie requête HTTP** pour mesurer la latence et confirmer l'accès internet.
4. **`providers/network_provider.dart`** expose cet état à l'UI et notifie les widgets à l'écoute.
5. **`screens/` et `widgets/`** affichent l'état en temps réel via `ListenableBuilder`.
6. En parallèle, **`services/firestore_service.dart`** persiste chaque rapport dans Firestore, sous `users/{uid}/reports/{reportId}`.

### Structure des dossiers

```
lib/
├── main.dart                  # Point d'entrée : Firebase, thème, langue, routing
│
├── models/
│   ├── network_report.dart    # Modèle d'un rapport de diagnostic
│   └── network_status.dart    # Enum : wifi, mobile, none
│
├── providers/                  # State management (ChangeNotifier)
│   ├── network_provider.dart
│   ├── history_provider.dart
│   ├── auth_provider.dart
│   └── language_provider.dart
│
├── services/                   # Logique métier
│   ├── network_service.dart
│   ├── firestore_service.dart
│   ├── auth_service.dart
│   └── export_service.dart
│
├── platform/
│   └── network_channel.dart   # Interface Dart du MethodChannel
│
├── screens/
│   ├── home_screen.dart
│   ├── history_screen.dart
│   ├── details_screen.dart
│   ├── login_screen.dart
│   ├── register.dart
│   └── onboarding_screen.dart
│
├── widgets/
│   ├── status_card.dart
│   ├── history_tile.dart
│   ├── export_button.dart
│   ├── circuit_background.dart
│   └── language_toggle.dart
│
├── theme/
│   └── app_theme.dart          # Thèmes clair / sombre
│
├── gen_l10n/                    # Fichiers de traduction générés
└── firebase_options.dart        # Généré par flutterfire configure

android/app/src/main/kotlin/.../MainActivity.kt   # Code natif Android
ios/Runner/AppDelegate.swift                       # Code natif iOS (non testé)
```

### Choix de state management

Le projet **n'utilise aucun package externe** de state management (pas de `provider`, `riverpod`, `bloc`, `get`). À la place :

- Chaque provider hérite de `ChangeNotifier` (natif Flutter) et appelle `notifyListeners()` après chaque changement d'état.
- Les providers sont **instanciés une seule fois** dans `AppStartup` (`main.dart`) et transmis aux écrans **via leur constructeur**, jamais via `Consumer<>`.
- L'UI écoute les changements avec `ListenableBuilder`, un widget natif de Flutter.

**Justification** : pour un projet de cette taille, cette approche offre une séparation claire des responsabilités sans ajouter de dépendance, tout en restant simple à expliquer et à déboguer.

### Modèle de données

`NetworkReport` — un rapport de diagnostic complet :

| Champ | Type | Description |
|---|---|---|
| `id` | `String` | Identifiant unique (généré par Firestore) |
| `timestamp` | `DateTime` | Date et heure du diagnostic |
| `connectionType` | `NetworkStatus` | `wifi`, `mobile`, ou `none` |
| `isConnected` | `bool` | Accès internet réellement confirmé |
| `signalStrength` | `int?` | RSSI en dBm (Wifi) ou niveau 0-4 (mobile) |
| `ipAddress` | `String?` | Adresse IP locale |
| `ssid` | `String?` | Nom du réseau Wifi connecté |
| `latencyMs` | `int?` | Latence mesurée (requête HTTP réelle) |
| `batteryLevel` | `int?` | Pourcentage de batterie (0-100) |
| `userId` | `String` | UID Firebase du propriétaire |

### Sécurité Firestore

```
users/{userId}/reports/{reportId}
```

Chaque utilisateur ne peut lire et écrire que ses propres rapports :


## Démarrage du projet

### Prérequis

- Flutter SDK installé (`flutter --version` pour vérifier)
- Un compte Google pour Firebase
- Node.js (pour Firebase CLI)

### Installation

```bash
git clone https://github.com/AbdoulRazaque226/NetworkChecker.git
cd NetworkChecker
flutter pub get
```

### Lancer l'application

```bash
flutter run
```

>  Sur Android, un popup système demandera les permissions de localisation et d'état du téléphone au premier lancement — nécessaires pour lire le SSID et le signal cellulaire. Accepte-les pour un fonctionnement complet.

---

## Configuration Firebase

Si tu configures ton propre projet Firebase :

```bash
npm install -g firebase-tools
firebase login

dart pub global activate flutterfire_cli
flutterfire configure
```

Active ensuite, dans la [Console Firebase](https://console.firebase.google.com) :

1. **Authentication** → Sign-in method → activer **Anonymous** et **Email/Password**
2. **Firestore Database** → créer une base, puis appliquer les règles de sécurité ci-dessus


## Permissions Android

Le fichier `android/app/src/main/AndroidManifest.xml` doit contenir, **avant** la balise `<application>` :

```xml
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
```

> Ces permissions sont nécessaires pour lire le SSID Wifi et le niveau de signal cellulaire. Sans elles, l'app compile mais ces informations resteront indisponibles.


## Workflow Git


- Chaque membre travaille sur sa propre branche `feature/...`, créée depuis `dev`.
- Une Pull Request est ouverte vers `dev` une fois la tâche testée.
- La fusion `dev → main` se fait uniquement pour une version stable validée.
- **Règle établie** : toujours commiter son travail avant de merger `dev` dans sa branche, pour éviter tout écrasement de fichiers modifiés localement.



## Pistes d'amélioration

- Tests automatisés (unitaires sur les services/providers, widgets sur l'UI)
- CI/CD via GitHub Actions
- Graphiques d'évolution de la connectivité dans le temps
- Notifications en cas de perte de connexion prolongée
- Passage d'un compte anonyme à un compte email pour retrouver l'historique sur un autre appareil

---

*NetworkChecker — Mini-Hackathon FFSC 2026*
