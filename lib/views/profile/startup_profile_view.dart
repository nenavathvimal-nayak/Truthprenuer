import 'package:flutter/material.dart';
import '../../components/avatar_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';

class StartupProfileView extends StatefulWidget {
  final Startup startup;

  const StartupProfileView({super.key, required this.startup});

  @override
  State<StartupProfileView> createState() => _StartupProfileViewState();
}

class _StartupProfileViewState extends State<StartupProfileView> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: colors.text, size: 28),
          onPressed: () {
            HapticManager.shared.impactLight();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: colors.text),
            onPressed: () {
              HapticManager.shared.impactLight();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image / Header
            Stack(
              alignment: Alignment.bottomLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: colors.cardBackgroundLight,
                ),
                Positioned(
                  bottom: -40,
                  left: AppSpacing.lg,
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.startup.name.isNotEmpty ? widget.startup.name[0] : "",
                      style: AppTypography.metric.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            
            // Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.startup.name,
                              style: AppTypography.title1.copyWith(color: colors.text),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${widget.startup.industry} • ${widget.startup.stage}",
                              style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticManager.shared.impactMedium();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            "Track Evidence",
                            style: AppTypography.headline.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.startup.description,
                    style: AppTypography.editorialQuote.copyWith(color: colors.text),
                  ),
                  
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(Icons.link, color: colors.textSecondary, size: 16),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        "startup.com",
                        style: AppTypography.subheadline.copyWith(color: colors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  _TabButton(
                    title: "About",
                    isSelected: _selectedTab == 0,
                    onTap: () {
                      setState(() => _selectedTab = 0);
                      HapticManager.shared.selection();
                    },
                  ),
                  _TabButton(
                    title: "Updates",
                    isSelected: _selectedTab == 1,
                    onTap: () {
                      setState(() => _selectedTab = 1);
                      HapticManager.shared.selection();
                    },
                  ),
                  _TabButton(
                    title: "Roles",
                    isSelected: _selectedTab == 2,
                    onTap: () {
                      setState(() => _selectedTab = 2);
                      HapticManager.shared.selection();
                    },
                  ),
                ],
              ),
            ),
            Container(height: 1, color: colors.divider),
            
            // Tab Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _buildTabContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    if (_selectedTab == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Team", style: AppTypography.title3.copyWith(color: colors.text)),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const AvatarView(name: "Founder", imageURL: null, size: 50),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Alex (CEO)", style: AppTypography.headline.copyWith(color: colors.text)),
                    Text("Technical Founder", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_selectedTab == 1) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Beta Launch Next Week!", style: AppTypography.headline.copyWith(color: colors.text)),
            const SizedBox(height: 4),
            Text("We are excited to announce our closed beta. Join the waitlist now.", style: AppTypography.body.copyWith(color: colors.textSecondary)),
            const SizedBox(height: 4),
            Text("2 days ago", style: AppTypography.caption.copyWith(color: colors.primary)),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text("Co-Founder (Marketing)", style: AppTypography.headline.copyWith(color: colors.text))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text("Equity", style: AppTypography.caption.copyWith(color: colors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text("Looking for someone to handle GTM strategy and user acquisition.", style: AppTypography.body.copyWith(color: colors.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () {
                HapticManager.shared.impactLight();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: colors.cardBackgroundLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text("Apply", style: AppTypography.subheadline.copyWith(color: colors.text)),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Text(
                title,
                style: AppTypography.headline.copyWith(
                  color: isSelected ? colors.primary : colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                height: 2,
                color: isSelected ? colors.primary : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
