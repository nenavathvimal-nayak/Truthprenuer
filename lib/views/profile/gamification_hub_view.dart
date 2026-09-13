import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../utils/haptic_manager.dart';

class GamificationHubView extends StatefulWidget {
  const GamificationHubView({super.key});

  @override
  State<GamificationHubView> createState() => _GamificationHubViewState();
}

class _GamificationHubViewState extends State<GamificationHubView> {
  int _selectedTab = 0; // 0: Achievements, 1: Leaderboard
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_selectedTab != index) {
      HapticManager.shared.selection();
      setState(() {
        _selectedTab = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text("Your Progress", style: AppTypography.appBarTitle.copyWith(color: colors.text)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header Status
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md, left: AppSpacing.lg, right: AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Lvl 7",
                      style: AppTypography.title2.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Execution Score", style: AppTypography.headline.copyWith(color: colors.text)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text("3,450 XP", style: AppTypography.title3.copyWith(color: colors.primary)),
                            const SizedBox(width: 4),
                            Text("/ 5,000 XP", style: AppTypography.subheadline.copyWith(color: colors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Container(
                                  height: 8,
                                  width: constraints.maxWidth * 0.69,
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Segmented Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    title: "Achievements",
                    isSelected: _selectedTab == 0,
                    onTap: () => _onTabTapped(0),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    title: "Leaderboard",
                    isSelected: _selectedTab == 1,
                    onTap: () => _onTabTapped(1),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: colors.divider, height: 1),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _selectedTab = index);
              },
              children: const [
                _AchievementsTabView(),
                _LeaderboardTabView(),
              ],
            ),
          ),
        ],
      ),
    );
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              title,
              style: AppTypography.subheadline.copyWith(
                color: isSelected ? colors.primary : colors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Container(
            height: 2,
            color: isSelected ? colors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _AchievementsTabView extends StatelessWidget {
  const _AchievementsTabView();

  final List<Map<String, dynamic>> badges = const [
    {"title": "First Spark", "desc": "Post your first validation idea.", "earned": true, "icon": Icons.lightbulb},
    {"title": "7-Day Streak", "desc": "Validate ideas 7 days in a row.", "earned": true, "icon": Icons.local_fire_department},
    {"title": "Community Voice", "desc": "Leave 50 helpful comments.", "earned": false, "icon": Icons.chat_bubble_outline},
    {"title": "Top 10%", "desc": "Reach the top 10% on the leaderboard.", "earned": false, "icon": Icons.emoji_events},
    {"title": "Early Adopter", "desc": "Join TAEED during beta.", "earned": true, "icon": Icons.star},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.75,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _BadgeCardView(
          title: badge["title"],
          description: badge["desc"],
          isEarned: badge["earned"],
          icon: badge["icon"],
        );
      },
    );
  }
}

class _BadgeCardView extends StatefulWidget {
  final String title;
  final String description;
  final bool isEarned;
  final IconData icon;

  const _BadgeCardView({
    required this.title,
    required this.description,
    required this.isEarned,
    required this.icon,
  });

  @override
  State<_BadgeCardView> createState() => _BadgeCardViewState();
}

class _BadgeCardViewState extends State<_BadgeCardView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isEarned) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isEarned ? colors.primary.withOpacity(0.3) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Opacity(
        opacity: widget.isEarned ? 1.0 : 0.6,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Stack(
              alignment: Alignment.center,
              children: [
                if (widget.isEarned)
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 70, height: 70,
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.3 * (1.15 - _pulseAnimation.value + 1.0) / 1.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: widget.isEarned ? colors.primary.withOpacity(0.1) : colors.cardBackgroundLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    size: 24,
                    color: widget.isEarned ? colors.primary : colors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.title,
              style: AppTypography.headline.copyWith(color: colors.text),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              widget.description,
              style: AppTypography.caption.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardTabView extends StatelessWidget {
  const _LeaderboardTabView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return ListView.builder(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      itemCount: 10,
      itemBuilder: (context, index) {
        final isYou = index == 3;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              color: isYou ? colors.primary.withOpacity(0.1) : colors.background,
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      "${index + 1}",
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: index < 3 ? colors.primary : colors.textSecondary,
                      ),
                    ),
                  ),
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: colors.cardBackgroundLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isYou ? "You (TAEED Builder)" : "Founder ${index + 1}",
                          style: AppTypography.headline.copyWith(color: colors.text),
                        ),
                        Text(
                          "Lvl ${20 - index}",
                          style: AppTypography.caption.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${10000 - (index * 500)} XP",
                    style: AppTypography.subheadline.copyWith(color: colors.primary),
                  ),
                ],
              ),
            ),
            if (index < 9)
              Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Divider(color: colors.divider, height: 1),
              ),
          ],
        );
      },
    );
  }
}
