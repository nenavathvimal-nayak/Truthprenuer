import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';

class ValidationMarketplaceView extends ConsumerStatefulWidget {
  const ValidationMarketplaceView({super.key});

  @override
  ConsumerState<ValidationMarketplaceView> createState() => _ValidationMarketplaceViewState();
}

class _ValidationMarketplaceViewState extends ConsumerState<ValidationMarketplaceView> {
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "AI", "SaaS", "FinTech", "HealthTech", "Consumer", "B2B"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);
    
    final validations = dataStore.validationsNeedingFeedback().where((v) {
      return _selectedCategory == "All" || v.tags.contains(_selectedCategory);
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          "Validate Ideas",
          style: AppTypography.appBarTitle.copyWith(color: colors.text),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Category Filter
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: GestureDetector(
                            onTap: () {
                              HapticManager.shared.selection();
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: isSelected ? colors.primary : colors.cardBackgroundLight,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                category,
                                style: AppTypography.caption.copyWith(
                                  color: isSelected ? Colors.white : colors.text,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Divider(color: colors.divider, height: 1, thickness: 1),
                ],
              ),
            ),
            
            // Idea List
            if (validations.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, left: AppSpacing.lg, right: AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified, size: 40, color: colors.textTertiary),
                      const SizedBox(height: AppSpacing.sm),
                      Text("No ideas need validation", style: AppTypography.title3.copyWith(color: colors.text)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        "Check back later or try a different category.",
                        style: AppTypography.body.copyWith(color: colors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final validation = validations[index];
                      final author = dataStore.users.firstWhere((u) => u.id == validation.authorId);
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: GestureDetector(
                          onTap: () {
                            context.push(
                              '/structured-feedback',
                              extra: {
                                'validation': validation,
                                'author': author,
                              },
                            );
                          },
                          child: _MarketplaceCard(validation: validation, author: author),
                        ),
                      );
                    },
                    childCount: validations.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MarketplaceCard extends StatelessWidget {
  final ValidationRequest validation;
  final User? author;

  const _MarketplaceCard({required this.validation, this.author});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author info
          Row(
            children: [
              AvatarView(name: author?.name ?? "Founder", imageURL: author?.avatarURL, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  author?.name ?? "Founder",
                  style: AppTypography.caption.copyWith(color: colors.textSecondary),
                ),
              ),
              Text(
                validation.createdAt.timeAgoDisplay,
                style: AppTypography.caption2.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Content
          Text(
            validation.title,
            style: AppTypography.headline.copyWith(color: colors.text),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            validation.problem,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Footer
          Row(
            children: [
              ...validation.tags.take(2).map((tag) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        tag,
                        style: AppTypography.caption2.copyWith(color: colors.primary),
                      ),
                    ),
                  )),
              const Spacer(),
              
              Row(
                children: [
                  Icon(Icons.timer_outlined, size: 14, color: colors.textSecondary),
                  const SizedBox(width: 4),
                  Text("2 min", style: AppTypography.caption2.copyWith(color: colors.textSecondary)),
                ],
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Icon(Icons.bolt, size: 14, color: colors.warning),
                  const SizedBox(width: 4),
                  Text("+50", style: AppTypography.caption2.copyWith(color: colors.warning)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
