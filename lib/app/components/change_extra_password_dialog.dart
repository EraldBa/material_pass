import 'package:flutter/material.dart';
import 'package:material_pass/helpers/hive_helper.dart';

class ChangeExtraPasswordDialog extends StatefulWidget {
  const ChangeExtraPasswordDialog({super.key});

  @override
  State<ChangeExtraPasswordDialog> createState() =>
      _ChangeExtraPasswordDialogState();
}

class _ChangeExtraPasswordDialogState extends State<ChangeExtraPasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _newPassword = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change ExtraPassword'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Enter current ExtraPassword'),
                validator: (value) {
                  final validated = HiveHelper.instance.userInfo
                      .matchExtraPassword(value ?? '');

                  if (validated) {
                    return null;
                  }

                  return 'ExtraPassword is not correct';
                },
              ),
              TextFormField(
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Enter new ExtraPassword'),
                onChanged: (value) {
                  _newPassword = value;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm new ExtraPassword',
                ),
                validator: (value) {
                  if (value != _newPassword) {
                    return 'ExtraPasswords do not match!';
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

              userInfo.extraPassword = _newPassword;
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
