import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/network_report.dart';

/// Firestore persistence layer for network diagnostic reports.
///
/// Data layout (see NetworkChecker_Repartition_Taches.docx §4.4):
///
///   users/{uid}/reports/{reportId}
///
/// Each user owns its own sub-collection, isolated by the Firebase uid. This
/// layout keeps queries cheap and lets the security rules below restrict access
/// with a single rule.
///
/// Recommended Firestore security rules — paste into the Firebase console
/// (Firestore → Rules) so every user can only read/write its own data:
/// ----------------------------------------------------------------------------
///   rules_version = '2';
///   service cloud.firestore {
///     match /databases/{database}/documents {
///       match /users/{uid}/reports/{reportId} {
///         allow read, write: if request.auth != null && request.auth.uid == uid;
///       }
///     }
///   }
/// ----------------------------------------------------------------------------
class FirestoreService {
  /// Injects [FirebaseFirestore] so tests can pass a fake; defaults to the
  /// real instance configured by the Firebase initialization.
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Returns the `users/{uid}/reports` sub-collection handle.
  CollectionReference<Map<String, dynamic>> _reportsRef(String uid) =>
      _firestore.collection('users').doc(uid).collection('reports');

  /// Persists [report] and returns it with its Firestore-generated document id.
  ///
  /// The database is the source of truth for `reportId`; the returned copy is
  /// the one to keep in the local history list.
  Future<NetworkReport> saveReport(NetworkReport report) async {
    // `doc()` without an id lets Firestore generate a unique reportId.
    final DocumentReference<Map<String, dynamic>> docRef =
        _reportsRef(report.userId).doc();
    await docRef.set(_toFirestoreMap(report, id: docRef.id));
    return report.copyWith(id: docRef.id);
  }

  /// Reads the full history of [uid], newest first (ordered by timestamp).
  Future<List<NetworkReport>> getReports(String uid) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _reportsRef(uid).orderBy('timestamp', descending: true).get();
    return snapshot.docs.map(_fromFirestoreDoc).toList();
  }

  /// Deletes the report [id] from the history of user [uid].
  Future<void> deleteReport(String uid, String id) async {
    await _reportsRef(uid).doc(id).delete();
  }

  /// Serializes a report for storage, converting [DateTime] into a Firestore
  /// `Timestamp` so the history can be ordered and queried server-side.
  Map<String, dynamic> _toFirestoreMap(NetworkReport report,
      {required String id}) {
    return <String, dynamic>{
      'id': id,
      'timestamp': Timestamp.fromDate(report.timestamp),
      'connectionType': report.connectionType.name,
      'isConnected': report.isConnected,
      'signalStrength': report.signalStrength,
      'ipAddress': report.ipAddress,
      'ssid': report.ssid,
      'latencyMs': report.latencyMs,
      'userId': report.userId,
    };
  }

  /// Rebuilds a [NetworkReport] from a Firestore document snapshot, converting
  /// the stored `Timestamp` back into a `DateTime`.
  NetworkReport _fromFirestoreDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    final dynamic ts = data['timestamp'];
    final Map<String, dynamic> normalized = <String, dynamic>{...data};
    if (ts is Timestamp) {
      normalized['timestamp'] = ts.toDate();
    }
    // The document id is authoritative and may differ from `data['id']`.
    return NetworkReport.fromJson(<String, dynamic>{...normalized, 'id': doc.id});
  }
}