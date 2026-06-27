import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

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
  late StreamSubscription _intentSub;

  @override
  void initState() {
    super.initState();

    // Listen to media sharing when app is running (in background/foreground)
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      _handleSharedMedia(value);
    }, onError: (err) {
      debugPrint("getMediaStream error: $err");
    });

    // Get the media shared when app is opened from closed state
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      if (value.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleSharedMedia(value);
        });
      }
      ReceiveSharingIntent.instance.reset();
    });
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  void _handleSharedMedia(List<SharedMediaFile> value) {
    if (value.isEmpty) return;
    for (var file in value) {
      // Print detailed log as requested by the user
      debugPrint("[SHARE TARGET LOG] Path: ${file.path}");
      debugPrint("[SHARE TARGET LOG] Type: ${file.type}");
      
      // Console output explicitly showing the share URL
      print("[SHARE TARGET] Received share URL: ${file.path}");

      // Also present a user-friendly snackbar indicating the receipt of shared URL
      if (mounted) {
        setState(() {
          _selectedIndex = 1; // Automatically switch to the Jobs tab
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Shared Link: ${file.path}"),
              backgroundColor: Theme.of(context).colorScheme.primary,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        });
      }
    }
  }

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
