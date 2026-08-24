import 'package:flutter_test/flutter_test.dart';
import 'package:video_compressor_plus_example/main.dart';

void main() {
  testWidgets('renders the compress action', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    expect(find.text('Pick and compress a video'), findsOneWidget);
  });
}
