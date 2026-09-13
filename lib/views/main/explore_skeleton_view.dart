import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';

class ExploreSkeletonView extends StatelessWidget {
  const ExploreSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar Skeleton
          const Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
            child: _SkeletonCard(height: 50),
          ),
          
          // Trending Startups Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _SkeletonText(width: 150),
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: List.generate(
                3,
                (index) => const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.md),
                  child: _SkeletonCard(width: 160, height: 180),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Top Founders Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _SkeletonText(width: 120),
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: List.generate(
                5,
                (index) => const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.lg),
                  child: Column(
                    children: [
                      _SkeletonCard(width: 64, height: 64, isCircle: true),
                      SizedBox(height: 8),
                      _SkeletonText(width: 50, height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Ideas Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _SkeletonText(width: 180),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: List.generate(
                3,
                (index) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: _SkeletonCard(height: 180),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  final double? width;
  final double height;
  final bool isCircle;

  const _SkeletonCard({this.width, required this.height, this.isCircle = false});

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: colors.cardBackgroundLight.withOpacity(_animation.value),
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.isCircle ? null : BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}

class _SkeletonText extends StatefulWidget {
  final double width;
  final double height;

  const _SkeletonText({required this.width, this.height = 16});

  @override
  State<_SkeletonText> createState() => _SkeletonTextState();
}

class _SkeletonTextState extends State<_SkeletonText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: colors.cardBackgroundLight.withOpacity(_animation.value),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}
