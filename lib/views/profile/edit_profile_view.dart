import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../components/avatar_picker_modal.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
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
      final user = ref.read(mockDataStoreProvider).currentUser;
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

  void _saveProfile() {
    HapticManager.shared.impactMedium();
    setState(() => _isSaving = true);
    
    final skills = _skillsCtrl.text.split(",")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        ref.read(mockDataStoreProvider).updateProfile(
          name: _nameCtrl.text,
          bio: _bioCtrl.text,
          role: _roleCtrl.text,
          website: _websiteCtrl.text,
          twitter: _twitterCtrl.text,
          location: _locationCtrl.text,
          skills: skills,
        );
        setState(() {
          _isSaving = false;
          _saveSuccess = true;
        });
        HapticManager.shared.notificationSuccess(); // notification success
        
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) Navigator.pop(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Scaffold(
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg).copyWith(bottom: 50),
        child: Column(
          children: [
            // Avatar section
            Consumer(
              builder: (context, ref, _) {
                final user = ref.watch(mockDataStoreProvider).currentUser;
                return GestureDetector(
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
            
            _BioEditField(label: "Bio", placeholder: "Tell the TAEED community who you are...", controller: _bioCtrl),
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
