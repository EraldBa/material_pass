import 'package:flutter/material.dart';
import 'package:material_pass/app/pages/home_page.dart';
import 'package:material_pass/app/pages/nuke_page.dart';
import 'package:material_pass/helpers/hive_helper.dart';
import 'package:material_pass/models/user_info.dart';

class ExtraPasswordPage extends StatefulWidget {
  const ExtraPasswordPage({super.key});

  static const String route = '/extra-password';

  @override
  State<ExtraPasswordPage> createState() => _ExtraPasswordPageState();
}

class _ExtraPasswordPageState extends State<ExtraPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _nukeAll = false;

  String? _validator(String? value) {
    final UserInfo userInfo = HiveHelper.instance.userInfo;

    final bool verified = userInfo.matchExtraPassword(value ?? '');

    if (verified) {
      userInfo.resetTries();

      return null;
    }

    if (--userInfo.extraPasswordTries > 0) {
      userInfo.save();

      return '${userInfo.extraPasswordTries} tries left before complete nuke of all data!';
    }

    setState(() {
      _nukeAll = true;
    });

    return 'NUKE ALL';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter ExtraPassword'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                  'PIN entered too many times, extra password is required now.'),
              TextFormField(
                obscureText: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: _validator,
              ),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).popAndPushNamed(HomePage.route);
                    return;
                  }

                  if (_nukeAll) {
                    HiveHelper.nukeAll().then((_) {
                      Navigator.of(context).popAndPushNamed(NukePage.route);
                    });
                    // exit the app
                  }
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
