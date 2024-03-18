import 'package:flutter/material.dart';
import 'package:material_pass/app/pages/ready_to_go_page.dart';
import 'package:material_pass/app/pages/set_up_user_info.dart';
import 'package:material_pass/app/pages/welcome_page.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          WelcomePage(pageController: _pageController),
          SetUpUserInfoPage(pageController: _pageController),
          const ReadyToGoPage(),
        ],
      ),
    );
  }
}
