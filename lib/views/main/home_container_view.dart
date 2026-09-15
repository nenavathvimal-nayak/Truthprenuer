import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../models/role_provider.dart';
import 'founder_home_view.dart';
import 'investor_home_view.dart';
import 'professional_home_view.dart';
import 'creator_home_view.dart';
import 'student_home_view.dart';

class HomeContainerView extends ConsumerWidget {
  const HomeContainerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(roleProvider);

    return switch (currentRole) {
      UserRole.founder => const FounderHomeView(),
      UserRole.investor => const InvestorHomeView(),
      UserRole.professional => const ProfessionalHomeView(),
      UserRole.creator => const CreatorHomeView(),
      UserRole.student => const StudentHomeView(),
    };
  }
}
