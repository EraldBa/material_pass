import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_pass/app/pages/entry_page.dart';
import 'package:material_pass/app/pages/extra_password_page.dart';
import 'package:material_pass/app/pages/home_page.dart';
import 'package:material_pass/app/pages/nuke_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const appColor = Colors.lightBlueAccent;

  static final theme = ThemeData(
    fontFamily: 'Ubuntu',
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: appColor,
    ),
    brightness: SchedulerBinding.instance.platformDispatcher.platformBrightness,
    colorSchemeSeed: appColor,
    useMaterial3: true,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Pass',
      theme: theme,
      home: const EntryPage(),
      routes: {
        HomePage.route: (context) => const HomePage(),
        ExtraPasswordPage.route: (context) => const ExtraPasswordPage(),
        NukePage.route: (context) => const NukePage(),
      },
    );
  }
}
