import 'package:flutter/material.dart';
import 'package:material_pass/helpers/hive_helper.dart';
import 'package:material_pass/helpers/show_helper.dart';

class RemoveCategoryDialog extends StatefulWidget {
  const RemoveCategoryDialog({super.key});

  @override
  State<RemoveCategoryDialog> createState() => _RemoveCategoryDialogState();
}

class _RemoveCategoryDialogState extends State<RemoveCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    final List<String> categories = HiveHelper.categories.toList();

    return AlertDialog(
      title: const Text('Remove vault category'),
      content: SizedBox(
        height: 150.0,
        width: 150.0,
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            return Card(
              child: ListTile(
                leading: const Icon(Icons.category_outlined),
                title: Text(category),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ShowHelper.confirmationDialog(
                      context,
                      title: 'Delete item "$category"',
                    ).then((confirmed) {
                      if (confirmed) {
                        setState(() {
                          HiveHelper.removeCategory(index, category);
                        });
                      }
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        )
      ],
    );
  }
}
