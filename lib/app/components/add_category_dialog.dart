import 'package:flutter/material.dart';
import 'package:material_pass/helpers/hive_helper.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _category = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new category'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(hintText: 'Category'),
          onChanged: (value) => _category = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Provided category is empty!';
            }

            if (HiveHelper.categories.contains(value)) {
              return 'Category already exists!';
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              HiveHelper.categoryBox.add(_category);
              Navigator.of(context).pop(_category);
            }
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
