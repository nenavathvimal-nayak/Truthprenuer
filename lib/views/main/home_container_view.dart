import 'package:flutter/material.dart';
import 'founder_home_view.dart';
import '../validation/validation_wizard_view.dart';
import '../messaging/chats_list_view.dart';

class HomeContainerView extends StatefulWidget {
  const HomeContainerView({super.key});

  @override
  State<HomeContainerView> createState() => _HomeContainerViewState();
}

class _HomeContainerViewState extends State<HomeContainerView> {
  final PageController _pageController = PageController(initialPage: 1); // Starts on FounderHomeView (Index 1)

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: const [
        ValidationWizardView(),
        FounderHomeView(),
        ChatsListView(),
      ],
    );
  }
}
