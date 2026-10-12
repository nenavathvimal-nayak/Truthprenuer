import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../components/avatar_picker_modal.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/models.dart';
import '../../repositories/app_providers.dart';
import '../../utils/haptic_manager.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _twitterCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  
  bool _isSaving = false;
  bool _saveSuccess = false;

  final List<String> _availableRoles = [
    "Founder", "Co-Founder", "CTO", "Designer", "Engineer", 
    "Investor", "Solo Founder", "Product Manager", "Growth Lead", "Community Builder"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider).value;
      if (user != null) {
        setState(() {
          _nameCtrl.text = user.name;
          _bioCtrl.text = user.bio;
          _roleCtrl.text = user.role;
          _websiteCtrl.text = user.website;
          _twitterCtrl.text = user.twitterHandle;
          _locationCtrl.text = user.location;
          _skillsCtrl.text = user.skills.join(", ");
        });
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _roleCtrl.dispose();
    _websiteCtrl.dispose();
    _twitterCtrl.dispose();
    _locationCtrl.dispose();
    _skillsCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    HapticManager.shared.impactMedium();
    setState(() => _isSaving = true);
    
    final skills = _skillsCtrl.text.split(",")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        name: _nameCtrl.text.trim(),
        bio: _bioCtrl.text.trim(),
        role: _roleCtrl.text.trim(),
        website: _websiteCtrl.text.trim(),
        twitterHandle: _twitterCtrl.text.trim(),
        location: _locationCtrl.text.trim(),
        skills: skills,
      );

      await ref.read(profileRepositoryProvider).saveProfile(updatedUser);
      ref.invalidate(currentUserProvider);
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
        _saveSuccess = true;
      });
      HapticManager.shared.notificationSuccess();
      
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/profile');
        }
      });
    }
  }

  bool _isDirty(User? user) {
    if (user == null) return false;
    if (_nameCtrl.text.trim() != user.name) return true;
    if (_bioCtrl.text.trim() != user.bio) return true;
    if (_roleCtrl.text.trim() != user.role) return true;
    if (_websiteCtrl.text.trim() != user.website) return true;
    if (_twitterCtrl.text.trim() != user.twitterHandle) return true;
    if (_locationCtrl.text.trim() != user.location) return true;
    final currentSkills = _skillsCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (currentSkills.join(',') != user.skills.join(',')) return true;
    return false;
  }

  Future<bool> _confirmDiscardChanges(BuildContext context) async {
    final colors = Theme.of(context).appColors;
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text("Discard unsaved changes?", style: TextStyle(color: colors.text)),
        content: Text("You have unsaved changes that will be lost.", style: TextStyle(color: colors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Keep Editing"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: colors.destructive),
            child: const Text("Discard"),
          ),
        ],
      ),
    );
    return shouldDiscard ?? false;
  }

  void _handleBackNavigation(BuildContext context, User? user) async {
    if (_isDirty(user)) {
      final discard = await _confirmDiscardChanges(context);
      if (!discard || !context.mounted) return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final currentUser = ref.watch(currentUserProvider).value;
    
    return PopScope(
      canPop: !_isDirty(currentUser),
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        _handleBackNavigation(context, currentUser);
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.background,
          elevation: 0,
          title: Text("Edit Profile", style: AppTypography.appBarTitle.copyWith(color: colors.text)),
          centerTitle: true,
          leading: IconButton(
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: colors.cardBackgroundLight, shape: BoxShape.circle),
              child: Icon(Icons.close, color: colors.textSecondary, size: 18),
            ),
            tooltip: "Close",
            onPressed: () => _handleBackNavigation(context, currentUser),
          ),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg).copyWith(bottom: 50),
        child: Column(
          children: [
            // Avatar section
            Consumer(
              builder: (context, ref, _) {
                final user = ref.watch(currentUserProvider).value;
                return Semantics(
                  label: "Change profile photo",
                  button: true,
                  child: GestureDetector(
                    onTap: () {
                      HapticManager.shared.impactLight();
                      AvatarPickerModal.show(context);
                    },
                    child: Column(
                      children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          user?.avatarURL != null && user!.avatarURL!.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    user.avatarURL!,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, err, stack) => Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      child: Text(
                                        _nameCtrl.text.isNotEmpty ? _nameCtrl.text[0].toUpperCase() : "A",
                                        style: AppTypography.display.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _nameCtrl.text.isNotEmpty ? _nameCtrl.text[0].toUpperCase() : "A",
                                    style: AppTypography.display.copyWith(color: Colors.white),
                                  ),
                                ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: colors.background, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Change Photo",
                        style: AppTypography.caption.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
            const SizedBox(height: AppSpacing.xl),

            // Fields
            _EditField(label: "Full Name", icon: Icons.person, placeholder: "Your full name", controller: _nameCtrl),
            const SizedBox(height: AppSpacing.md),
            
            _EditField(label: "Role / Title", icon: Icons.work, placeholder: "e.g. Founder, Designer, Engineer", controller: _roleCtrl),
            const SizedBox(height: AppSpacing.sm),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _availableRoles.map((r) {
                  final isSelected = _roleCtrl.text == r;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () {
                        HapticManager.shared.selection();
                        setState(() {
                          _roleCtrl.text = r;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? colors.primary : colors.cardBackgroundLight,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          r,
                          style: AppTypography.caption.copyWith(color: isSelected ? Colors.white : colors.textSecondary),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            
            _BioEditField(label: "Bio", placeholder: "Tell the TRUTHPRENUER community who you are...", controller: _bioCtrl),
            const SizedBox(height: AppSpacing.md),
            
            _EditField(label: "Location", icon: Icons.location_on, placeholder: "City, Country", controller: _locationCtrl),
            const SizedBox(height: AppSpacing.md),
            
            _EditField(label: "Website", icon: Icons.link, placeholder: "https://yoursite.com", controller: _websiteCtrl, keyboardType: TextInputType.url),
            const SizedBox(height: AppSpacing.md),
            
            _EditField(label: "Twitter / X", icon: Icons.alternate_email, placeholder: "@handle", controller: _twitterCtrl),
            const SizedBox(height: AppSpacing.md),
            
            _EditField(label: "Skills (comma-separated)", icon: Icons.star, placeholder: "e.g. Design, SwiftUI, Growth", controller: _skillsCtrl),
            const SizedBox(height: AppSpacing.xl),
            
            // Save Button
            GestureDetector(
              onTap: _isSaving ? null : _saveProfile,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: _saveSuccess ? colors.success : colors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isSaving)
                      const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    else if (_saveSuccess)
                      const Icon(Icons.check, color: Colors.white, size: 16)
                    else
                      const Icon(Icons.arrow_upward, color: Colors.white, size: 16),
                      
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      _isSaving ? "Saving..." : _saveSuccess ? "Saved!" : "Save Changes",
                      style: AppTypography.headline.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}

class _EditField extends StatefulWidget {
  final String label;
  final IconData icon;
  final String placeholder;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _EditField({
    required this.label, required this.icon, required this.placeholder, 
    required this.controller, this.keyboardType = TextInputType.text
  });

  @override
  State<_EditField> createState() => _EditFieldState();
}

class _EditFieldState extends State<_EditField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(widget.label, style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused ? colors.primary.withValues(alpha: 0.6) : colors.border,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 18, color: _isFocused ? colors.primary : colors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  style: AppTypography.body.copyWith(color: colors.text),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: AppTypography.body.copyWith(color: colors.textTertiary),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BioEditField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;

  const _BioEditField({required this.label, required this.placeholder, required this.controller});

  @override
  State<_BioEditField> createState() => _BioEditFieldState();
}

class _BioEditFieldState extends State<_BioEditField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textLength = widget.controller.text.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Text(widget.label, style: AppTypography.caption.copyWith(color: colors.textSecondary)),
              const Spacer(),
              Text(
                "$textLength/200", 
                style: AppTypography.caption2.copyWith(
                  color: textLength > 180 ? colors.warning : colors.textTertiary
                )
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused ? colors.primary.withValues(alpha: 0.6) : colors.border,
              width: 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLines: 4,
            onChanged: (_) => setState(() {}),
            style: AppTypography.body.copyWith(color: colors.text),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: AppTypography.body.copyWith(color: colors.textTertiary),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
