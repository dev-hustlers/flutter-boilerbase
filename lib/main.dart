import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_boilerbase/services/revenue_cat_service.dart';
import 'firebase_options.dart';
import 'auth_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await RevenueCatService.init();
  runApp(const ProviderScope(child: MyApp()));
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
      home: const AuthPage(),
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

  @override
  void initState() {
    super.initState();
    // Show the paywall automatically when the MainScreen loads
    _checkAndShowPaywall();
  }

  void _checkAndShowPaywall() async {
    await RevenueCatService.presentPaywall();
  }

  final List<Widget> _pages = [
    EmptyStatePage(icon: PhosphorIcons.house(), text: 'Home page shown here'),
    EmptyStatePage(
      icon: PhosphorIcons.shoppingCart(),
      text: 'Orders page shown here',
    ),
    EmptyStatePage(icon: PhosphorIcons.rss(), text: 'Feeds appear here'),
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
          NavigationDestination(icon: Icon(PhosphorIcons.rss()), label: 'Feed'),
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
