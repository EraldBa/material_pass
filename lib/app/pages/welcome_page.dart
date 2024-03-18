import 'package:flutter/material.dart';
import 'package:material_pass/helpers/adaptive_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyanAccent,
            Colors.deepPurpleAccent,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Welcome to Material Pass!',
            style: TextStyle(
              fontSize: AdaptiveScreen.isBigScreen(context) ? 50.0 : 30.0,
              color: Colors.black,
            ),
          ),
          Image.asset(
            'assets/images/lock.png',
            scale: 1.5,
          ),
          FilledButton(
            child: const Text('Get started ->'),
            onPressed: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear,
              );
            },
          )
        ],
      ),
    );
  }
}
