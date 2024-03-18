import 'package:flutter/material.dart';
import 'package:material_pass/app/widgets/pin_form_field.dart';
import 'package:material_pass/helpers/adaptive_screen.dart';
import 'package:material_pass/helpers/hive_helper.dart';
import 'package:material_pass/models/user_info.dart';

class SetUpUserInfoPage extends StatefulWidget {
  const SetUpUserInfoPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<SetUpUserInfoPage> createState() => _SetUpUserInfoPageState();
}

class _SetUpUserInfoPageState extends State<SetUpUserInfoPage> {
  static const SizedBox _separator = SizedBox(height: 30.0);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _pin = '';
  String _extraPassword = '';

  String? _mandatoryFieldValidator(String? value) {
    return value == null || value.isEmpty ? 'This field this required!' : null;
  }

  String? _initialPinValidator(String? value) {
    final String? mandatoryValidatorValue = _mandatoryFieldValidator(value);

    if (mandatoryValidatorValue != null) {
      return mandatoryValidatorValue;
    }

    if (value!.length < 4) {
      return 'PIN too short!';
    }

    return null;
  }

  String? _pinValidator(String? value) {
    if (_pin != value) {
      return "PIN's don't match!";
    }

    return null;
  }

  String? _extraPasswordValidator(String? value) {
    if (_extraPassword != value) {
      return "ExtraPassword's don't match!";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurpleAccent,
            Colors.lightBlueAccent,
          ],
        ),
      ),
      child: ConstrainedBox(
        constraints: AdaptiveScreen.isBigScreen(context)
            ? const BoxConstraints(
                maxHeight: 1000.0,
                maxWidth: 600.0,
              )
            : const BoxConstraints(
                maxHeight: 900,
                maxWidth: 400.0,
              ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Set up your security, this will only take a second.',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                _separator,
                PinFormField(
                  inputDecoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    label: Text('PIN  (numbers only)'),
                  ),
                  validator: _initialPinValidator,
                  onChanged: (value) {
                    _pin = value;
                    if (value.length == 4) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
                _separator,
                PinFormField(
                  inputDecoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    label: Text('Confirm PIN'),
                  ),
                  validator: _pinValidator,
                  onChanged: (value) {
                    if (value.length == 4) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
                _separator,
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    label: Text('ExtraPassword'),
                  ),
                  obscureText: true,
                  validator: _mandatoryFieldValidator,
                  onChanged: (value) => _extraPassword = value,
                ),
                _separator,
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    label: Text('Confirm ExtraPassword'),
                  ),
                  obscureText: true,
                  validator: _extraPasswordValidator,
                ),
                _separator,
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final userInfo = UserInfo(
                        pin: _pin,
                        extraPassword: _extraPassword,
                      );

                      HiveHelper.createUser(userInfo).then((_) {
                        widget.pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.linear,
                        );
                      });
                    }
                  },
                  child: const Text('Done'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
