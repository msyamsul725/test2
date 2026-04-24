import 'package:flutter_test/flutter_test.dart';

import 'package:company_profile/main.dart';

void main() {
  testWidgets('renders company profile content', (WidgetTester tester) async {
    await tester.pumpWidget(const CompanyProfileApp());

    expect(find.text('Arunika Consulting Group'), findsWidgets);
    expect(
      find.text(
        'Mitra strategis untuk perusahaan yang ingin tampil lebih kredibel, modern, dan siap tumbuh.',
      ),
      findsOneWidget,
    );
    expect(find.text('Layanan Kami'), findsOneWidget);
    expect(find.text('Hubungi Kami'), findsOneWidget);
  });
}
