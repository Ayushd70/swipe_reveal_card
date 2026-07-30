import 'package:flutter/material.dart';
import 'package:swipe_reveal_card/swipe_reveal_card.dart';

void main() {
  runApp(const SwipeRevealCardDemo());
}

class SwipeRevealCardDemo extends StatelessWidget {
  const SwipeRevealCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'swipe_reveal_card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B4DFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF2F4F8),
      ),
      home: const DemoHomePage(),
    );
  }
}

class _DemoItem {
  const _DemoItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  final List<_DemoItem> _items = [
    const _DemoItem(
      id: '1',
      title: 'Design sync',
      subtitle: 'Review the new card component',
      icon: Icons.design_services_outlined,
    ),
    const _DemoItem(
      id: '2',
      title: 'Ship checklist',
      subtitle: 'Docs, tests, and pub.dev dry-run',
      icon: Icons.checklist_rtl_outlined,
    ),
    const _DemoItem(
      id: '3',
      title: 'Customer feedback',
      subtitle: 'Swipe actions felt natural',
      icon: Icons.forum_outlined,
    ),
    const _DemoItem(
      id: '4',
      title: 'Release notes',
      subtitle: 'Draft the 0.1.0 changelog',
      icon: Icons.notes_outlined,
    ),
  ];

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _remove(_DemoItem item) {
    setState(() => _items.removeWhere((e) => e.id == item.id));
    _snack('Deleted "${item.title}"');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe Reveal Card'),
        centerTitle: false,
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return SwipeRevealCard(
            storageKey: 'demo-${item.id}',
            onTap: () => _snack('Opened "${item.title}"'),
            actionsBackgroundColor: const Color(0xFFE8ECFF),
            actions: [
              SwipeAction(
                label: 'Edit',
                icon: Icons.edit_outlined,
                onPressed: () => _snack('Edit "${item.title}"'),
              ),
              SwipeAction(
                label: 'Archive',
                icon: Icons.archive_outlined,
                color: const Color(0xFF0B7A4B),
                onPressed: () => _snack('Archived "${item.title}"'),
              ),
              SwipeAction(
                label: 'Delete',
                icon: Icons.delete_outline,
                color: scheme.error,
                onPressed: () => _remove(item),
              ),
            ],
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: scheme.primaryContainer,
                foregroundColor: scheme.onPrimaryContainer,
                child: Icon(item.icon, size: 22),
              ),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(item.subtitle),
              trailing: Icon(Icons.chevron_left, color: scheme.outline),
            ),
          );
        },
      ),
    );
  }
}
