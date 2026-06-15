import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Boilerbase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    EmptyStatePage(
      icon: PhosphorIcons.house(),
      text: 'Home page shown here',
    ),
    EmptyStatePage(
      icon: PhosphorIcons.shoppingCart(),
      text: 'Orders page shown here',
    ),
    EmptyStatePage(
      icon: PhosphorIcons.rss(),
      text: 'Feeds appear here',
    ),
    EmptyStatePage(
      icon: PhosphorIcons.gear(),
      text: 'Settings page shown here',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(PhosphorIcons.house()),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIcons.shoppingCart()),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIcons.rss()),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIcons.gear()),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class EmptyStatePage extends StatelessWidget {
  final PhosphorIconData icon;
  final String text;

  const EmptyStatePage({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
