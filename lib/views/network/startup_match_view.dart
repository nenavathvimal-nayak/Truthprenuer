import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/tag_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';

class StartupMatchView extends ConsumerStatefulWidget {
  const StartupMatchView({super.key});

  @override
  ConsumerState<StartupMatchView> createState() => _StartupMatchViewState();
}

class _StartupMatchViewState extends ConsumerState<StartupMatchView> {
  List<User> _candidates = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataStore = ref.read(mockDataStoreProvider);
      setState(() {
        _candidates = dataStore.users.where((u) => u.id != dataStore.currentUser?.id).toList();
      });
    });
  }

  void _swipe(bool liked) {
    if (_candidates.isEmpty) return;
    HapticManager.shared.selection(); // Or impact based on preference
    setState(() {
      _candidates.removeAt(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Scaffold(
      backgroundColor: colors.cardBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              color: colors.background,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: colors.text),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text("Co-Founder Match", style: AppTypography.headline.copyWith(color: colors.text)),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.tune, color: colors.text),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Cards Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Stack(
                  children: [
                    if (_candidates.isEmpty)
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome, size: 48, color: colors.primary),
                            const SizedBox(height: AppSpacing.md),
                            Text("No more candidates nearby.", style: AppTypography.headline.copyWith(color: colors.textSecondary)),
                          ],
                        ),
                      )
                    else
                      ..._candidates.reversed.map((candidate) {
                        return _MatchCardView(
                          key: ValueKey(candidate.id),
                          user: candidate,
                          onSwipe: _swipe,
                        );
                      }),
                  ],
                ),
              ),
            ),
            
            // Bottom Actions
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RoundButton(
                    icon: Icons.close,
                    color: colors.primary,
                    backgroundColor: colors.cardBackgroundLight,
                    onTap: _candidates.isEmpty ? null : () => _swipe(false),
                  ),
                  const SizedBox(width: 40),
                  _RoundButton(
                    icon: Icons.check,
                    color: Colors.white,
                    backgroundColor: colors.primary,
                    onTap: _candidates.isEmpty ? null : () => _swipe(true),
                    shadowColor: colors.primary.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final Color? shadowColor;

  const _RoundButton({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    this.onTap,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: onTap == null ? backgroundColor.withOpacity(0.5) : backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            if (onTap != null)
              BoxShadow(
                color: shadowColor ?? Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Icon(icon, color: onTap == null ? color.withOpacity(0.5) : color, size: 28),
      ),
    );
  }
}

class _MatchCardView extends StatefulWidget {
  final User user;
  final Function(bool) onSwipe;

  const _MatchCardView({super.key, required this.user, required this.onSwipe});

  @override
  State<_MatchCardView> createState() => _MatchCardViewState();
}

class _MatchCardViewState extends State<_MatchCardView> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final rotation = _offset.dx / 40.0;
    
    return Positioned.fill(
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _offset += details.delta;
          });
        },
        onPanEnd: (details) {
          if (_offset.dx > 100) {
            widget.onSwipe(true);
          } else if (_offset.dx < -100) {
            widget.onSwipe(false);
          } else {
            setState(() {
              _offset = Offset.zero;
            });
          }
        },
        child: Transform.translate(
          offset: _offset,
          child: Transform.rotate(
            angle: rotation * 3.14159 / 180,
            child: Container(
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                gradient: LinearGradient(
                  colors: [colors.primary.withOpacity(0.2), colors.cardBackground],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Placeholder for real photo is the gradient background
                  
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.name,
                            style: AppTypography.h2.copyWith(color: colors.text),
                          ),
                          Text(
                            widget.user.role,
                            style: AppTypography.headline.copyWith(color: colors.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.user.bio,
                            style: AppTypography.body.copyWith(color: colors.textSecondary),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: const [
                              TagView(title: "React Native"),
                              TagView(title: "SwiftUI"),
                              TagView(title: "Node.js"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
