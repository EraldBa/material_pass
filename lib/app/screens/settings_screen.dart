import 'package:flutter/material.dart';
import 'package:material_pass/app/components/add_category_dialog.dart';
import 'package:material_pass/app/components/change_extra_password_dialog.dart';
import 'package:material_pass/app/components/change_pin_dialog.dart';
import 'package:material_pass/app/components/remove_category_dialog.dart';
import 'package:material_pass/app/pages/nuke_page.dart';
import 'package:material_pass/helpers/hive_helper.dart';
import 'package:material_pass/helpers/show_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: const Text('Add vault category'),
            leading: const Icon(Icons.add),
            onTap: () {
              showDialog<String?>(
                context: context,
                builder: (context) {
                  return const AddCategoryDialog();
                },
              ).then((category) {
                if (category != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Category "$category" added!'),
                    ),
                  );
                }
              });
            },
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Remove vault category'),
            leading: const Icon(Icons.cancel),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const RemoveCategoryDialog();
                },
              );
            },
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Change pin'),
            leading: const Icon(Icons.pin_outlined),
            onTap: () {
              showDialog<bool?>(
                context: context,
                builder: (context) {
                  return const ChangePinDialog();
                },
              ).then((changed) {
                if (changed == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PIN changed successfully!'),
                    ),
                  );
                }
              });
            },
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Change extra-password'),
            leading: const Icon(Icons.password),
            onTap: () {
              showDialog<bool?>(
                context: context,
                builder: (context) {
                  return const ChangeExtraPasswordDialog();
                },
              ).then((changed) {
                if (changed == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ExtraPassword changed successfully!'),
                    ),
                  );
                }
              });
            },
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Nuke all data'),
            leading: const Icon(Icons.warning_amber),
            onTap: () {
              ShowHelper.confirmationDialog(
                context,
                title: 'WARNING',
                content:
                    'The entire database holding your info will be erased. Are you sure you want to continue?',
              ).then((confirmed) {
                if (confirmed) {
                  ShowHelper.pinConfirmationDialog(context).then((confirmed) {
                    if (confirmed) {
                      HiveHelper.nukeAllData().then((_) {
                        Navigator.of(context).popAndPushNamed(NukePage.route);
                      });
                    }
                  });
                }
              });
            },
          ),
        )
      ],
    );
  }
}
