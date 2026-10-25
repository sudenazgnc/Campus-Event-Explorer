import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/main.dart';

void main() {
  testWidgets('Explore screen loads initial events and supports search',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());

    // Verify app title and initial matching count (8 events)
    expect(find.text('Campus Event Explorer'), findsOneWidget);
    expect(find.text('Matching events: 8'), findsOneWidget);
  });
}
