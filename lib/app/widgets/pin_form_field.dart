import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_pass/helpers/hive_helper.dart';

class PinFormField extends StatelessWidget {
  const PinFormField({
    super.key,
    this.onChanged,
    this.validator,
    this.inputDecoration,
  });

  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final InputDecoration? inputDecoration;

  static String? defaultValidator(String? value) {
    final validated = HiveHelper.instance.userInfo.matchPin(value ?? '');

    if (validated) {
      return null;
    }

    return 'PIN is incorrect';
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 4,
      decoration: inputDecoration,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
