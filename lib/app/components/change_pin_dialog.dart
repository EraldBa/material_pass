import 'package:flutter/material.dart';
import 'package:material_pass/app/widgets/pin_form_field.dart';
import 'package:material_pass/helpers/hive_helper.dart';

class ChangePinDialog extends StatefulWidget {
  const ChangePinDialog({super.key});

  @override
  State<ChangePinDialog> createState() => _ChangePinDialogState();
}

class _ChangePinDialogState extends State<ChangePinDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _newPin = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change PIN'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const PinFormField(
                inputDecoration:
                    InputDecoration(labelText: 'Enter current PIN'),
                validator: PinFormField.defaultValidator,
              ),
              PinFormField(
                inputDecoration:
                    const InputDecoration(labelText: 'Enter new PIN'),
                onChanged: (value) {
                  _newPin = value;
                },
              ),
              PinFormField(
                inputDecoration:
                    const InputDecoration(labelText: 'Confirm new PIN'),
                validator: (value) {
                  if (value != _newPin) {
                    return 'PINs do not match!';
                  }

                  return null;
                },
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final userInfo = HiveHelper.instance.userInfo;

              userInfo.pin = _newPin;
              userInfo.save();

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
