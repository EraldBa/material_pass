import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_pass/helpers/hive_helper.dart';

class ConfirmWithPinDialog extends StatelessWidget {
  ConfirmWithPinDialog({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _pinValidator(String? value) {
    final bool validated = HiveHelper.userInfo.matchPin(value ?? '');

    if (validated) {
      return null;
    }

    return 'PIN is not valid';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter PIN to continue'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          obscureText: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 4,
          validator: _pinValidator,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(true);
            }
          },
          child: const Text('Done'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
