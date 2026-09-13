import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../utils/haptic_manager.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../components/tag_view.dart';
import '../../components/custom_text_field.dart';

class StartupSettingsView extends StatefulWidget {
  const StartupSettingsView({super.key});

  @override
  State<StartupSettingsView> createState() => _StartupSettingsViewState();
}

class _StartupSettingsViewState extends State<StartupSettingsView> {
  final _nameCtrl = TextEditingController(text: "TAEED");
  final _taglineCtrl = TextEditingController(text: "The world's first Startup Validation Network");
  final _websiteCtrl = TextEditingController(text: "https://taeed.app");

  String _industry = "Social / Tools";
  String _stage = "Pre-Seed";
  bool _isPublic = true;
  bool _showOnTalentBoard = true;
  bool _listedInInvestorFeed = false;

  final List<String> _industries = ["Social / Tools", "SaaS", "FinTech", "HealthTech", "AI / ML", "CleanTech", "Other"];
  final List<String> _stages = ["Idea", "Pre-Seed", "Seed", "Series A", "Series B+"];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _taglineCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  void _showPicker(BuildContext context, String title, List<String> items, String currentValue, ValueChanged<String> onChanged) {
    int selectedIndex = items.indexOf(currentValue);
    if (selectedIndex == -1) selectedIndex = 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).appColors.cardBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTypography.headline.copyWith(color: Theme.of(context).appColors.text)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text("Done", style: AppTypography.subheadline.copyWith(color: Theme.of(context).appColors.primary)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                  onSelectedItemChanged: (int index) {
                    onChanged(items[index]);
                  },
                  children: items.map((e) => Center(
                    child: Text(e, style: AppTypography.body.copyWith(color: Theme.of(context).appColors.text)),
                  )).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text("Startup Settings", style: AppTypography.appBarTitle.copyWith(color: colors.text)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticManager.shared.impactHeavy();
              Navigator.pop(context);
            },
            child: Text("Save", style: AppTypography.buttonLabel.copyWith(color: colors.primary)),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSectionHeader("Company Profile", colors),
          _buildTextFieldRow("Name", "Startup name", _nameCtrl, colors),
          _buildTextFieldRow("Tagline", "One-liner", _taglineCtrl, colors),
          _buildTextFieldRow("Website", "https://...", _websiteCtrl, colors, keyboardType: TextInputType.url),
          
          _buildSectionHeader("Classification", colors),
          _buildPickerRow("Industry", _industry, () => _showPicker(context, "Industry", _industries, _industry, (v) => setState(() => _industry = v)), colors),
          _buildPickerRow("Stage", _stage, () => _showPicker(context, "Stage", _stages, _stage, (v) => setState(() => _stage = v)), colors),
          
          _buildSectionHeader("Visibility", colors),
          _buildToggleRow("Public on Explore", _isPublic, (v) {
            HapticManager.shared.impactLight();
            setState(() => _isPublic = v);
          }, colors),
          _buildToggleRow("Show on Talent Board", _showOnTalentBoard, (v) => setState(() => _showOnTalentBoard = v), colors),
          _buildToggleRow("Listed in Investor Feed", _listedInInvestorFeed, (v) => setState(() => _listedInInvestorFeed = v), colors),
          
          _buildSectionHeader("Team", colors),
          ListTile(
            title: Text("Manage Team Members", style: AppTypography.body.copyWith(color: colors.text)),
            trailing: Icon(Icons.chevron_right, color: colors.textTertiary),
            tileColor: colors.cardBackground,
            onTap: () {
              context.push('/team-management');
            },
          ),
          
          _buildSectionHeader("Danger Zone", colors),
          ListTile(
            title: Text("Archive Startup", style: AppTypography.body.copyWith(color: colors.textSecondary)),
            tileColor: colors.cardBackground,
            onTap: () {},
          ),
          ListTile(
            title: Text("Delete Startup Profile", style: AppTypography.body.copyWith(color: colors.primary)),
            tileColor: colors.cardBackground,
            onTap: () {},
          ),
          
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
      child: Text(title.toUpperCase(), style: AppTypography.caption.copyWith(color: colors.textSecondary)),
    );
  }

  Widget _buildTextFieldRow(String label, String hint, TextEditingController controller, AppThemeColors colors, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      color: colors.cardBackground,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
            child: Row(
              children: [
                Text(label, style: AppTypography.body.copyWith(color: colors.text)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.right,
                    keyboardType: keyboardType,
                    style: AppTypography.body.copyWith(color: colors.textSecondary),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: AppTypography.body.copyWith(color: colors.textTertiary),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.divider, indent: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildPickerRow(String label, String value, VoidCallback onTap, AppThemeColors colors) {
    return Container(
      color: colors.cardBackground,
      child: Column(
        children: [
          ListTile(
            title: Text(label, style: AppTypography.body.copyWith(color: colors.text)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: AppTypography.body.copyWith(color: colors.textSecondary)),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: colors.textTertiary, size: 20),
              ],
            ),
            onTap: onTap,
          ),
          Divider(height: 1, color: colors.divider, indent: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, ValueChanged<bool> onChanged, AppThemeColors colors) {
    return Container(
      color: colors.cardBackground,
      child: Column(
        children: [
          SwitchListTile(
            title: Text(label, style: AppTypography.body.copyWith(color: colors.text)),
            value: value,
            onChanged: onChanged,
            activeTrackColor: colors.primary.withOpacity(0.5),
            activeColor: colors.primary,
          ),
          Divider(height: 1, color: colors.divider, indent: AppSpacing.md),
        ],
      ),
    );
  }
}

class TeamManagementView extends StatefulWidget {
  const TeamManagementView({super.key});

  @override
  State<TeamManagementView> createState() => _TeamManagementViewState();
}

class _TeamManagementViewState extends State<TeamManagementView> {
  final _emailCtrl = TextEditingController();
  String _inviteRole = "Viewer";
  bool _showInviteSent = false;

  final List<String> roles = ["Admin", "Editor", "Viewer"];

  final List<Map<String, dynamic>> members = [
    {"name": "Alex Rivera", "title": "Founder & CEO", "role": "Admin", "isAdmin": true},
    {"name": "Sana Khan", "title": "Head of Design", "role": "Editor", "isAdmin": false},
    {"name": "Tom Nguyen", "title": "Growth Lead", "role": "Editor", "isAdmin": false},
    {"name": "Maria Costa", "title": "Advisor", "role": "Viewer", "isAdmin": false},
  ];

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _sendInvite() {
    if (_emailCtrl.text.isEmpty) return;
    setState(() => _showInviteSent = true);
    HapticManager.shared.impactHeavy();
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showInviteSent = false;
          _emailCtrl.clear();
        });
      }
    });
  }

  Color _roleColor(String role, AppThemeColors colors) {
    switch (role) {
      case "Admin": return colors.primary;
      case "Editor": return colors.textSecondary;
      default: return colors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text("Team Management", style: AppTypography.appBarTitle.copyWith(color: colors.text)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg).copyWith(bottom: 100),
        child: Column(
          children: [
            // Invite Section
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Invite a Member", style: AppTypography.headline.copyWith(color: colors.text)),
                  const SizedBox(height: AppSpacing.md),
                  
                  CustomTextField(
                    controller: _emailCtrl,
                    placeholder: "Email address...",
                    icon: Icons.email_outlined,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  Row(
                    children: roles.map((role) => Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: TagView(
                        title: role,
                        isSelected: _inviteRole == role,
                        action: () {
                          setState(() => _inviteRole = role);
                        },
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  if (_showInviteSent)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: colors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text("Invitation sent!", style: AppTypography.subheadline.copyWith(color: colors.primary)),
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: _emailCtrl.text.isEmpty ? null : _sendInvite,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: _emailCtrl.text.isEmpty ? colors.cardBackgroundLight : colors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, color: _emailCtrl.text.isEmpty ? colors.textSecondary : Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Send Invite",
                              style: AppTypography.subheadline.copyWith(
                                color: _emailCtrl.text.isEmpty ? colors.textSecondary : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Current Members
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Current Members (${members.length})", style: AppTypography.headline.copyWith(color: colors.text)),
                const SizedBox(height: AppSpacing.md),
                
                ...members.map((member) {
                  final roleColor = _roleColor(member["role"], colors);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.divider, width: 1),
                    ),
                    child: Row(
                      children: [
                        AvatarView(name: member["name"], size: 44),
                        const SizedBox(width: AppSpacing.md),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(member["name"], style: AppTypography.subheadline.copyWith(color: colors.text)),
                                  if (member["isAdmin"]) ...[
                                    const SizedBox(width: 4),
                                    Icon(Icons.workspace_premium, color: colors.primary, size: 12),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(member["title"], style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                            ],
                          ),
                        ),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: roleColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            member["role"],
                            style: AppTypography.caption.copyWith(
                              color: roleColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
