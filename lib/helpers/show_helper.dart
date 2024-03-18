import 'package:flutter/material.dart';
import 'package:material_pass/app/components/confirm_with_pin_dialog.dart';
import 'package:material_pass/app/screens/vault_item_screen.dart';
import 'package:material_pass/models/vault_item.dart';

final class ShowHelper {
  static Future<bool> confirmationDialog(
    BuildContext context, {
    required String title,
    String? content,
  }) async {
    final bool? confirmation = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    return confirmation == true;
  }

  static Future<bool> vaultItemScreen(
    BuildContext context, {
    VaultItem? vaultItem,
  }) async {
    final bool? confirmation = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return VaultItemScreen(vaultItem: vaultItem);
      },
    );

    return confirmation == true;
  }

  static Future<bool> pinConfirmationDialog(BuildContext context) async {
    final bool? confirmation = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return ConfirmWithPinDialog();
      },
    );

    return confirmation == true;
  }
}
