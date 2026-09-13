import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../components/buttons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';

class CreatePostModalView extends ConsumerStatefulWidget {
  const CreatePostModalView({super.key});

  @override
  ConsumerState<CreatePostModalView> createState() => _CreatePostModalViewState();
}

class _CreatePostModalViewState extends ConsumerState<CreatePostModalView> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _bodyCtrl = TextEditingController();
  final List<String> _availableTags = ["Milestone", "Question", "Learnings", "Launch", "Hiring", "Feedback"];
  final Set<String> _selectedTags = {"Milestone"};
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _submitPost() async {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();
    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both title and post body.")),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    HapticManager.shared.impactMedium();

    final dataStore = ref.read(mockDataStoreProvider);
    final currentUser = dataStore.currentUser ??
        dataStore.users.firstWhere((u) => u.id == "me", orElse: () => dataStore.users.first);

    final newPost = PostItem(
      id: const Uuid().v4(),
      authorId: currentUser.id,
      title: title,
      body: body,
      tags: _selectedTags.toList(),
      likes: 0,
      commentsCount: 0,
      isLiked: false,
      isBookmarked: false,
      createdAt: DateTime.now(),
    );

    // Insert into mock store
    dataStore.posts.insert(0, newPost);
    dataStore.notify();

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    HapticManager.shared.notificationSuccess();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post published to the community feed!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        top: AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create Community Post",
                  style: AppTypography.title3.copyWith(color: colors.text),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: colors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Title input
            TextField(
              controller: _titleCtrl,
              style: AppTypography.headline.copyWith(color: colors.text),
              decoration: InputDecoration(
                hintText: "Post Title (e.g. Shipped our MVP!)",
                hintStyle: AppTypography.headline.copyWith(color: colors.textTertiary),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Tags
            Text(
              "TOPIC TAGS",
              style: AppTypography.caption.copyWith(
                color: colors.textTertiary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text("#$tag"),
                  selected: isSelected,
                  onSelected: (selected) {
                    HapticManager.shared.selection();
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                  selectedColor: colors.primary.withOpacity(0.2),
                  backgroundColor: colors.cardBackgroundLight,
                  labelStyle: AppTypography.caption.copyWith(
                    color: isSelected ? colors.primary : colors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? colors.primary : colors.border,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),

            // Body input
            TextField(
              controller: _bodyCtrl,
              maxLines: 5,
              style: AppTypography.body.copyWith(color: colors.text),
              decoration: InputDecoration(
                hintText: "Share your startup update, learnings, ask questions, or announce milestones...",
                hintStyle: AppTypography.body.copyWith(color: colors.textTertiary),
                filled: true,
                fillColor: colors.cardBackgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Submit Button
            PrimaryButton(
              title: _isSubmitting ? "Publishing..." : "Publish Post",
              action: _isSubmitting ? () {} : _submitPost,
            ),
          ],
        ),
      ),
    );
  }
}
