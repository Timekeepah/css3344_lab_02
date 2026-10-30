import 'package:first_flutter_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Photo and Cupertino picker work in both layouts', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 932);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const StudentInfoApp());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(ImageSection), 250);
    await tester.pumpAndSettle();
    final photo = tester.widget<Image>(
      find.descendant(of: find.byType(ImageSection), matching: find.byType(Image)),
    );
    expect((photo.image as AssetImage).assetName, 'assets/images/graveyard.jpg');

    final button = find.text('Open Cupertino Date Picker');
    await tester.scrollUntilVisible(button, 250);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.byType(CupertinoDatePicker), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    final dropdown = find.byType(DropdownButton<String>);
    await tester.scrollUntilVisible(dropdown, 200);
    await tester.pumpAndSettle();
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Developer').last);
    await tester.pumpAndSettle();
    expect(find.text('Selected role: Developer'), findsOneWidget);

    final roleButton = find.text('Open Cupertino Role Picker');
    await tester.scrollUntilVisible(roleButton, 150);
    await tester.pumpAndSettle();
    await tester.tap(roleButton);
    await tester.pumpAndSettle();
    final wheel = tester.widget<CupertinoPicker>(find.byType(CupertinoPicker));
    expect(wheel.scrollController!.selectedItem, 1);
    wheel.scrollController!.jumpToItem(2);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Selected role: Designer'), findsOneWidget);
    expect(tester.widget<DropdownButton<String>>(dropdown).value, 'Designer');

    tester.view.physicalSize = const Size(932, 430);
    await tester.pumpAndSettle();
    expect(find.text('Selected role: Designer'), findsOneWidget);
    expect(find.byType(ImageSection), findsOneWidget);
    await tester.scrollUntilVisible(
      button,
      150,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.byType(CupertinoDatePicker), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.byType(CupertinoDatePicker), findsNothing);

    await tester.scrollUntilVisible(
      roleButton,
      150,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(roleButton);
    await tester.pumpAndSettle();
    expect(
      tester.widget<CupertinoPicker>(find.byType(CupertinoPicker))
          .scrollController!.selectedItem,
      2,
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
  });
}
