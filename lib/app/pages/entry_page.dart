import 'package:flutter/material.dart';
import 'package:material_pass/app/pages/extra_password_page.dart';
import 'package:material_pass/app/screens/introduction_screen.dart';
import 'package:material_pass/app/screens/pin_screen.dart';
import 'package:material_pass/helpers/hive_helper.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HiveHelper.userExists
        ? (HiveHelper.instance.userInfo.pinTries > 0
            ? const PinScreen()
            : const ExtraPasswordPage())
        : const IntroductionScreen();
  }
}
