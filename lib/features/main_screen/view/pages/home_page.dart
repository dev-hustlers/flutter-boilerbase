import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1EAE58).withAlpha(180), // Audible-style vibrant green
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Curated intelligence for your career trajectory.',
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildProfileStrength(context),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: 'Document\nScan',
                      subtitle: 'ATS parsing check',
                      icon: LucideIcons.scan,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: 'Prep\nBriefing',
                      subtitle: 'Interview synthesis',
                      icon: LucideIcons.userCheck,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildActiveTrajectories(context),
              const SizedBox(height: 20),
              _buildCuratedIntelligence(context),
              const SizedBox(height: 48),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStrength(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Strength',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '87',
                  style: textTheme.displayLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
                  child: Text(
                    '/100 ATS',
                    style: textTheme.bodyMedium,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withAlpha(50),
                    borderRadius: BorderRadius.circular(4), 
                  ),
                  child: Text(
                    'High Fidelity',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 87,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 13,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your academic and professional taxonomy is well-structured. Recommended action: Quantify impact in recent roles.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Analyze Resume'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required String subtitle, required IconData icon}) {
    final theme = Theme.of(context);
    
    return AspectRatio(
      aspectRatio: 1, 
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 28),
              const Spacer(),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(height: 1.2),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTrajectories(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Trajectories',
                  style: theme.textTheme.headlineMedium,
                ),
                Icon(LucideIcons.listFilter, color: theme.colorScheme.onSurface, size: 20),
              ],
            ),
          ),
          const Divider(),
          _buildTrajectoryItem(
            context,
            company: 'Atlassian',
            role: 'Graduate Software Engineer',
            status: 'Urgent',
            statusDesc: 'Coding assessment due',
            statusColor: theme.colorScheme.errorContainer,
            statusTextColor: theme.colorScheme.error,
          ),
          const Divider(),
          _buildTrajectoryItem(
            context,
            company: 'Canva',
            role: 'Product Design Intern',
            status: 'Review',
            statusDesc: 'Portfolio reviewed',
            statusColor: theme.colorScheme.surfaceContainerHighest,
            statusTextColor: theme.colorScheme.onSurfaceVariant,
          ),
          const Divider(),
          _buildTrajectoryItem(
            context,
            company: 'Macquarie Group',
            role: 'Data Analyst',
            status: 'Submitted',
            statusDesc: 'Awaiting response',
            statusColor: Colors.transparent,
            statusTextColor: theme.colorScheme.onSurface,
            hasBorder: true,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTrajectoryItem(
    BuildContext context, {
    required String company,
    required String role,
    required String status,
    required String statusDesc,
    required Color statusColor,
    required Color statusTextColor,
    bool hasBorder = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(company, style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(role, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                    border: hasBorder ? Border.all(color: theme.colorScheme.outlineVariant) : null,
                  ),
                  child: Text(
                    status,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: statusTextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  statusDesc,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuratedIntelligence(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Cloud Intelligence',
              style: theme.textTheme.headlineMedium,
            ),
          ),
          const Divider(),
          _buildIntelligenceItem(
            context,
            icon: LucideIcons.lightbulb,
            title: 'Market Shift: FinTech Demand',
            description: 'Analysis indicates a 15% increase in quantitative roles...',
            actionText: 'Read Briefing',
          ),
          const Divider(),
          _buildIntelligenceItem(
            context,
            icon: LucideIcons.handshake,
            title: 'Alumni Network Activation',
            description: '3 alumni from your cohort have recently transitioned into roles...',
            actionText: 'View Connections',
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildIntelligenceItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String actionText,
  }) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Text(description, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                Text(
                  actionText,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
