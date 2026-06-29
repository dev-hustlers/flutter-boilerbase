import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:catalyst/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../prep_ai/view/pages/prep_pipeline_page.dart';
import 'pages/home_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
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
    final l10n = AppLocalizations.of(context)!;
    for (var file in value) {
      debugPrint("[SHARE TARGET LOG] Path: ${file.path}");
      debugPrint("[SHARE TARGET LOG] Type: ${file.type}");
      
      // ignore: avoid_print
      print("[SHARE TARGET] Received share URL: ${file.path}");

      if (mounted) {
        setState(() {
          _selectedIndex = 1; // Automatically switch to the Jobs tab
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.shareTargetLink(file.path)),
              backgroundColor: Theme.of(context).colorScheme.primary,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: l10n.dismiss,
                textColor: AppTokens.surfaceContainerLowest,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final windowSize = MediaQuery.sizeOf(context);
    
    // Branching Logic based on Material 3 guidelines
    final useSideNavRail = windowSize.width >= 600;

    final List<Widget> pages = [
      const HomePage(),
      EmptyStatePage(
        icon: LucideIcons.briefcase,
        text: l10n.jobsPageShown,
      ),
      EmptyStatePage(
        icon: LucideIcons.file,
        text: l10n.resumePageShown,
      ),
      const PrepPipelinePage(),
      EmptyStatePage(
        icon: LucideIcons.user,
        text: l10n.profilePageShown,
      ),
    ];

    // Keep Content Safe and Constrained
    Widget bodyContent = SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: pages[_selectedIndex],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.search),
          onPressed: () {},
        ),
        title: const Icon(LucideIcons.atom, size: 28),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: useSideNavRail
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(icon: const Icon(LucideIcons.house), label: Text(l10n.navHome)),
                    NavigationRailDestination(
                      icon: const Icon(LucideIcons.briefcase),
                      label: Text(l10n.navJobs),
                    ),
                    NavigationRailDestination(icon: const Icon(LucideIcons.file), label: Text(l10n.navResume)),
                    NavigationRailDestination(
                      icon: const Icon(LucideIcons.bookOpen),
                      label: Text(l10n.navPrep),
                    ),
                    NavigationRailDestination(icon: const Icon(LucideIcons.user), label: Text(l10n.navProfile)),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: bodyContent), // Fills remaining space next to NavRail
              ],
            )
          : bodyContent,
      bottomNavigationBar: useSideNavRail
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: [
                NavigationDestination(icon: const Icon(LucideIcons.house), label: l10n.navHome),
                NavigationDestination(
                  icon: const Icon(LucideIcons.briefcase),
                  label: l10n.navJobs,
                ),
                NavigationDestination(icon: const Icon(LucideIcons.file), label: l10n.navResume),
                NavigationDestination(
                  icon: const Icon(LucideIcons.bookOpen),
                  label: l10n.navPrep,
                ),
                NavigationDestination(icon: const Icon(LucideIcons.user), label: l10n.navProfile),
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
