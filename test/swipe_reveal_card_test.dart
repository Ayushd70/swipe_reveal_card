import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swipe_reveal_card/swipe_reveal_card.dart';

void main() {
  testWidgets('renders child without actions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SwipeRevealCard(child: Text('Hello card'))),
      ),
    );

    expect(find.text('Hello card'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsNothing);
  });

  testWidgets('reveals actions when provided', (tester) async {
    var edited = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeRevealCard(
            storageKey: 'card-1',
            closeOnAction: false,
            actions: [
              SwipeAction(
                label: 'Edit',
                icon: Icons.edit,
                onPressed: () => edited = true,
              ),
              SwipeAction(label: 'Delete', color: Colors.red, onPressed: () {}),
            ],
            child: const SizedBox(
              height: 72,
              child: Center(child: Text('Swipe me')),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Swipe me'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(-220, 0),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(edited, isTrue);
  });

  testWidgets('closes after action when closeOnAction is true', (tester) async {
    final controller = SwipeRevealController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeRevealCard(
            controller: controller,
            closeOnAction: true,
            actions: [SwipeAction(label: 'Edit', onPressed: () {})],
            child: const SizedBox(
              height: 72,
              child: Center(child: Text('Swipe me')),
            ),
          ),
        ),
      ),
    );

    controller.open();
    await tester.pumpAndSettle();
    expect(controller.isOpen, isTrue);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(controller.isOpen, isFalse);
  });

  testWidgets('group keeps only one card open', (tester) async {
    final group = SwipeRevealGroup();
    final first = SwipeRevealController();
    final second = SwipeRevealController();
    addTearDown(first.dispose);
    addTearDown(second.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              SwipeRevealCard(
                controller: first,
                group: group,
                actions: [SwipeAction(label: 'One', onPressed: () {})],
                child: const SizedBox(
                  height: 72,
                  child: Center(child: Text('First')),
                ),
              ),
              SwipeRevealCard(
                controller: second,
                group: group,
                actions: [SwipeAction(label: 'Two', onPressed: () {})],
                child: const SizedBox(
                  height: 72,
                  child: Center(child: Text('Second')),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    first.open();
    await tester.pumpAndSettle();
    expect(first.isOpen, isTrue);

    second.open();
    await tester.pumpAndSettle();
    expect(second.isOpen, isTrue);
    expect(first.isOpen, isFalse);
  });

  testWidgets('disabled card cannot be swiped open', (tester) async {
    final controller = SwipeRevealController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeRevealCard(
            controller: controller,
            enabled: false,
            actions: [SwipeAction(label: 'Edit', onPressed: () {})],
            child: const SizedBox(
              height: 72,
              child: Center(child: Text('Locked')),
            ),
          ),
        ),
      ),
    );

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(-220, 0),
    );
    await tester.pumpAndSettle();

    expect(controller.isOpen, isFalse);
    expect(find.text('Edit'), findsOneWidget);
  });

  testWidgets('invokes onTap on card body', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeRevealCard(
            onTap: () => tapped = true,
            child: const SizedBox(
              height: 72,
              width: double.infinity,
              child: Text('Tap me'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tap me'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('supports custom action child', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeRevealCard(
            closeOnAction: false,
            actions: [
              SwipeAction(
                label: 'Custom',
                onPressed: () => pressed = true,
                child: const Text('CustomAction'),
              ),
            ],
            child: const SizedBox(
              height: 72,
              child: Center(child: Text('Card')),
            ),
          ),
        ),
      ),
    );

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(-220, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('CustomAction'));
    await tester.pump();
    expect(pressed, isTrue);
  });

  testWidgets('exposes action semantics from label', (tester) async {
    final controller = SwipeRevealController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeRevealCard(
            controller: controller,
            actions: [
              SwipeAction(
                label: 'Archive item',
                onPressed: () {},
                child: const Icon(Icons.archive),
              ),
            ],
            child: const SizedBox(
              height: 72,
              child: Center(child: Text('Card')),
            ),
          ),
        ),
      ),
    );

    controller.open();
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byIcon(Icons.archive)),
      matchesSemantics(label: 'Archive item', isButton: true),
    );
  });

  testWidgets('clamps actions pane with actionsExtentRatio', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeRevealCard(
            margin: EdgeInsets.zero,
            actionsExtentRatio: 0.25,
            actions: [
              SwipeAction(
                label: 'A very long action label that should be clamped',
                onPressed: () {},
              ),
            ],
            child: const SizedBox(
              height: 72,
              child: Center(child: Text('Card')),
            ),
          ),
        ),
      ),
    );

    final cardWidth = MediaQuery.sizeOf(
      tester.element(find.byType(SwipeRevealCard)),
    ).width;
    final maxWidths = tester
        .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
        .map((box) => box.constraints.maxWidth)
        .toList();

    expect(maxWidths, contains(moreOrLessEquals(cardWidth * 0.25)));
  });

  test('SwipeAction holds configured values', () {
    var pressed = false;
    final action = SwipeAction(
      label: 'Archive',
      color: Colors.blue,
      icon: Icons.archive,
      onPressed: () => pressed = true,
    );

    expect(action.label, 'Archive');
    expect(action.color, Colors.blue);
    expect(action.icon, Icons.archive);
    action.onPressed();
    expect(pressed, isTrue);
  });
}
