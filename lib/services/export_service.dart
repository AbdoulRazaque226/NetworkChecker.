import 'dart:convert';

import '../models/network_report.dart';

/// Serializes [NetworkReport]s into JSON.
///
/// This powers the "export" bonus feature of the project spec: it produces the
/// **content** of the exported file. Ben's `export_button.dart` calls these
/// methods and takes care of saving/sharing the resulting string on the device.
class ExportService {
  /// Serializes a single [report] as a compact JSON string.
  String exportReport(NetworkReport report) => jsonEncode(report.toJson());

  /// Serializes an entire [history] as a pretty-printed JSON string.
  ///
  /// The output is a readable array of report objects (oldest present in the
  /// list order given by the caller — normally newest first from Firestore).
  /// The pretty indent makes the generated file pleasant to open in an editor.
  String exportToJson(List<NetworkReport> reports) {
    final List<Map<String, dynamic>> items =
        reports.map((NetworkReport r) => r.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(items);
  }
}