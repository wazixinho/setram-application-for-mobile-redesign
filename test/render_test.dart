import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:etwassel_ui/models.dart';
import 'package:etwassel_ui/widgets/card_face.dart';

void main() {
  testWidgets('card face renders the original card back', (tester) async {
    final card = demoCards().first;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(412, 915)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: SizedBox(width: 412, child: CardFace(card: card, width: 380))),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(CardFace), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rotated card keeps the portrait ratio', (tester) async {
    final card = demoCards().first;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(412, 915)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: RotatedCard(card: card, width: 300)),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(RotatedCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
