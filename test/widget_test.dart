import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airin_app/main.dart';

void main() {
  testWidgets('AirinApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AirinApp()));
    expect(find.byType(AirinApp), findsOneWidget);
  });
}
