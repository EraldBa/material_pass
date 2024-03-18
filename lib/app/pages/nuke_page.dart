import 'package:flutter/material.dart';

class NukePage extends StatelessWidget {
  const NukePage({super.key});

  static const String route = '/nuked';

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Your data has been nuked!',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.red,
                ),
              ),
              Image(image: AssetImage('assets/images/nuke_folder.png')),
              Text('The data loss is irreversible, please exit the app.')
            ],
          ),
        ),
      ),
    );
  }
}
