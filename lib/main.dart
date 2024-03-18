import 'package:flutter/material.dart';
import 'package:material_pass/app/app.dart';
import 'package:material_pass/helpers/hive_helper.dart';

Future<void> main() async {
  await HiveHelper.initHive();

  runApp(const App());
}
