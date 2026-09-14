import 'package:flutter_test/flutter_test.dart';
import 'package:network_checker/main.dart';

/// Placeholder widget test.
///
/// This file was emptied by the team and an empty `*_test.dart` file makes
/// `flutter test` fail (no `main()`). It is replaced by a trivial smoke test
/// that only checks the app entry-point class exists. Ben should replace it
/// with real widget tests once the screens are wired in `main.dart`.
void main() {
  testWidgets('app entry point exists', (WidgetTester tester) async {
    expect(MyApp, isA<Type>());
  });
}