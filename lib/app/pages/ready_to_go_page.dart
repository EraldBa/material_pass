import 'package:flutter/material.dart';
import 'package:material_pass/app/pages/home_page.dart';

class ReadyToGoPage extends StatelessWidget {
  const ReadyToGoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightBlueAccent,
            Colors.tealAccent,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.done,
            size: 40.0,
          ),
          const SizedBox(height: 40.0),
          const Text(
            'All ready to go!',
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 100.0),
          FilledButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed(HomePage.route);
            },
            child: const Text('Go to home page'),
          )
        ],
      ),
    );
  }
}
