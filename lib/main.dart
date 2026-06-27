import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    const EmptyStatePage(
      icon: LucideIcons.house,
      text: 'Home page shown here',
    ),
    const EmptyStatePage(
      icon: LucideIcons.briefcase,
      text: 'Jobs page shown here',
    ),
    const EmptyStatePage(
      icon: LucideIcons.file,
      text: 'Resume appear here',
    ),
    const EmptyStatePage(
      icon: LucideIcons.bookOpen,
      text: 'Prep page shown here',
    ),
    const EmptyStatePage(
      icon: LucideIcons.user,
      text: 'Profile page shown here',
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
        destinations: const [
          NavigationDestination(icon: Icon(LucideIcons.house), label: 'Home'),
          NavigationDestination(
            icon: Icon(LucideIcons.briefcase),
            label: 'Jobs',
          ),
          NavigationDestination(icon: Icon(LucideIcons.file), label: 'Resume'),
          NavigationDestination(
            icon: Icon(LucideIcons.bookOpen),
            label: 'Prep',
          ),
          NavigationDestination(icon: Icon(LucideIcons.user), label: 'Profile'),
        ],
      ),
    );
  }
}

class EmptyStatePage extends StatelessWidget {
  final IconData icon;
  final String text;

  const EmptyStatePage({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
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
