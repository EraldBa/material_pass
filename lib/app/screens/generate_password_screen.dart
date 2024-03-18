import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneratePasswordScreen extends StatefulWidget {
  const GeneratePasswordScreen({super.key});

  @override
  State<GeneratePasswordScreen> createState() => _GeneratePasswordScreenState();
}

class _GeneratePasswordScreenState extends State<GeneratePasswordScreen> {
  static const String _upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _lowerCase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _numbers = '1234567890';
  static const String _symbols = '!@#\$%^&*()<>,./';

  static final _thumbIcon = MaterialStateProperty.resolveWith<Icon?>((states) {
    if (states.contains(MaterialState.selected)) {
      return const Icon(Icons.check);
    }

    return const Icon(Icons.clear);
  });

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _includeCharsController = TextEditingController();
  final Random _random = Random.secure();

  int _passwordLength = 15;

  bool _upperCaseSelected = true;
  bool _lowerCaseSelected = true;
  bool _numbersSelected = true;
  bool _symbolsSelected = true;

  String _generatePassword() {
    String password = '';
    String seed = _includeCharsController.text;

    if (_upperCaseSelected) {
      seed += _upperCase;
    }

    if (_lowerCaseSelected) {
      seed += _lowerCase;
    }

    if (_numbersSelected) {
      seed += _numbers;
    }

    if (_symbolsSelected) {
      seed += _symbols;
    }

    if (seed.isEmpty) {
      throw Exception('No selection made!');
    }

    final List<String> seedList = seed.split('');

    final bool useUniqueCharacters = _passwordLength < seed.length;

    for (int i = 0; i < _passwordLength; ++i) {
      late String randomChar;

      do {
        final int index = _random.nextInt(seedList.length);
        randomChar = seedList[index];
      } while (useUniqueCharacters && password.contains(randomChar));

      password += randomChar;
    }

    return password;
  }

  @override
  void dispose() {
    _includeCharsController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextField(
          controller: _passwordController,
          readOnly: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Card(
                child: ListTile(
                  title: const Text('Copy password to clipboard'),
                  trailing: const Icon(Icons.copy),
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: _passwordController.text),
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Generated password copied to clipboard!'),
                        ),
                      );
                    });
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Generate password'),
                  trailing: const Icon(Icons.refresh),
                  onTap: () {
                    try {
                      _passwordController.text = _generatePassword();
                    } on Exception catch (e) {
                      ScaffoldMessenger.of(context).showMaterialBanner(
                        MaterialBanner(
                          content: Text(e.toString()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentMaterialBanner();
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 40.0),
              ListTile(
                title: Text('Password length: $_passwordLength'),
                subtitle: Slider(
                  min: 1.0,
                  max: 30.0,
                  divisions: 30,
                  value: _passwordLength.toDouble(),
                  label: _passwordLength.toString(),
                  onChanged: (value) {
                    setState(() {
                      _passwordLength = value.toInt();
                    });
                  },
                ),
              ),
              SwitchListTile(
                thumbIcon: _thumbIcon,
                value: _upperCaseSelected,
                onChanged: (value) {
                  setState(() {
                    _upperCaseSelected = value;
                  });
                },
                title: const Text('UpperCase Letters'),
              ),
              SwitchListTile(
                thumbIcon: _thumbIcon,
                value: _lowerCaseSelected,
                onChanged: (value) {
                  setState(() {
                    _lowerCaseSelected = value;
                  });
                },
                title: const Text('LowerCase Letters'),
              ),
              SwitchListTile(
                thumbIcon: _thumbIcon,
                value: _numbersSelected,
                onChanged: (value) {
                  setState(() {
                    _numbersSelected = value;
                  });
                },
                title: const Text('Numbers'),
              ),
              SwitchListTile(
                thumbIcon: _thumbIcon,
                value: _symbolsSelected,
                onChanged: (value) {
                  setState(() {
                    _symbolsSelected = value;
                  });
                },
                title: const Text('Symbols'),
              ),
              const SizedBox(height: 60.0),
              ListTile(
                title: TextField(
                  controller: _includeCharsController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Include characters',
                    suffixIcon: IconButton(
                      onPressed: _includeCharsController.clear,
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  onChanged: (value) => _includeCharsController.text = value,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
