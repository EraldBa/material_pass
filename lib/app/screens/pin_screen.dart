import 'package:flutter/material.dart';
import 'package:material_pass/app/pages/extra_password_page.dart';
import 'package:material_pass/app/pages/home_page.dart';
import 'package:material_pass/app/widgets/pin_form_field.dart';
import 'package:material_pass/helpers/hive_helper.dart';
import 'package:material_pass/models/user_info.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _rejected = false;

  String? _validateInfo(String? value) {
    final UserInfo userInfo = HiveHelper.userInfo;

    final bool verified = userInfo.matchPin(value!);

    if (verified) {
      userInfo.resetTries();

      return null;
    }

    if (--userInfo.pinTries > 0) {
      userInfo.save();

      _formKey.currentState!.reset();

      return 'PIN is incorrect. You have ${userInfo.pinTries} tries left';
    }

    setState(() {
      _rejected = true;
    });

    return 'REJECTED';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Form(
            key: _formKey,
            child: PinFormField(
              inputDecoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.blueGrey),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.length == 4) {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).popAndPushNamed(HomePage.route);
                    return;
                  }

                  if (_rejected) {
                    Navigator.of(context)
                        .popAndPushNamed(ExtraPasswordPage.route);
                  }
                }
              },
              validator: _validateInfo,
            )),
      ),
    );
  }
}
