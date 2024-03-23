import 'package:flutter/material.dart';
import 'package:material_pass/app/app.dart';
import 'package:material_pass/helpers/adaptive_screen.dart';
import 'package:material_pass/helpers/show_helper.dart';
import 'package:material_pass/models/vault_item.dart';

class VaultItemTile extends StatefulWidget {
  const VaultItemTile({
    super.key,
    required this.vaultItem,
    required this.onDelete,
    required this.onEdit,
  });

  final VaultItem vaultItem;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  State<VaultItemTile> createState() => _VaultItemTileState();
}

class _VaultItemTileState extends State<VaultItemTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: App.appColor.withOpacity(0.1),
      key: ValueKey(widget.vaultItem),
      leading: const Icon(Icons.key),
      title: Text(widget.vaultItem.websiteName),
      iconColor: Colors.white,
      onExpansionChanged: (expanded) {
        if (expanded) {
          setState(() {
            widget.vaultItem.isPasswordVisible = false;
          });
        }
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              widget.vaultItem.copyPasswordToClipboard().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password copied to clipboard!'),
                    duration: Duration(milliseconds: 900),
                  ),
                );
              });
            },
          ),
          const SizedBox(width: 15.0),

          /// Favorite option
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Edit item'),
                      Icon(Icons.edit),
                    ],
                  ),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        ShowHelper.vaultItemScreen(
                          context,
                          vaultItem: widget.vaultItem,
                        ).then((added) {
                          if (added) {
                            widget.onEdit();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Vault item "${widget.vaultItem.websiteName}" successfully modified!',
                                ),
                              ),
                            );
                          }
                        });
                      },
                    );
                  },
                ),

                ///Delete option
                PopupMenuItem(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delete item'),
                      Icon(Icons.delete),
                    ],
                  ),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ShowHelper.confirmationDialog(
                        context,
                        title: 'Confirmation needed',
                        content:
                            'Are you sure you want to delete password for website: "${widget.vaultItem.websiteName}?" This action cannot be undone',
                      ).then((confirmed) {
                        if (confirmed) {
                          widget.vaultItem.delete();

                          widget.onDelete();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Password for website "${widget.vaultItem.websiteName}" deleted!'),
                            ),
                          );
                        }
                      });
                    });
                  },
                ),
              ];
            },
          )
        ],
      ),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: AdaptiveScreen.isBigScreen(context)
                ? TableBorder.all(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(20.0),
                  )
                : null,
            columns: const [
              DataColumn(label: Text('Password')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Website')),
              DataColumn(label: Text('Website URL')),
              DataColumn(label: Text('Category')),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        Text(
                          widget.vaultItem.isPasswordVisible
                              ? widget.vaultItem.password
                              : widget.vaultItem.obscuredPassword,
                        ),
                        const SizedBox(width: 20.0),
                        IconButton(
                          icon: widget.vaultItem.isPasswordVisible
                              ? const Icon(Icons.visibility_outlined)
                              : const Icon(Icons.visibility_off_outlined),
                          onPressed: () {
                            setState(() {
                              widget.vaultItem.isPasswordVisible =
                                  !widget.vaultItem.isPasswordVisible;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    SelectableText(widget.vaultItem.username),
                  ),
                  DataCell(
                    SelectableText(widget.vaultItem.websiteName),
                  ),
                  DataCell(
                    SelectableText(
                      widget.vaultItem.websiteUrl ?? 'Not available',
                    ),
                    placeholder: widget.vaultItem.websiteUrl == null,
                  ),
                  DataCell(
                    Text(widget.vaultItem.category ?? 'Not available'),
                    placeholder: widget.vaultItem.category == null,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
