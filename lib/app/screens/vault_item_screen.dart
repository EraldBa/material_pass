import 'package:flutter/material.dart';
import 'package:material_pass/helpers/hive_helper.dart';
import 'package:material_pass/models/vault_item.dart';

class VaultItemScreen extends StatefulWidget {
  const VaultItemScreen({super.key, this.vaultItem});

  final VaultItem? vaultItem;

  @override
  State<VaultItemScreen> createState() => _VaultItemScreenState();
}

class _VaultItemScreenState extends State<VaultItemScreen> {
  static const EdgeInsets _defaultFormPadding = EdgeInsets.all(15.0);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final VaultItem _vaultItem;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _mandatoryFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != _vaultItem.password) {
      return 'Passwords do not match!';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    _vaultItem = widget.vaultItem ??
        VaultItem(
          password: '',
          username: '',
          websiteName: '',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        leadingWidth: 75.0,
        title: const Text('Vault Item Screen'),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                widget.vaultItem != null
                    ? await _vaultItem.save()
                    : await HiveHelper.vaultItemBox.add(_vaultItem);

                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Done'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: _defaultFormPadding,
                child: TextFormField(
                  initialValue: widget.vaultItem?.password,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    label: const Text('Password *'),
                    icon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility_off),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => _vaultItem.password = value,
                  validator: _mandatoryFieldValidator,
                ),
              ),
              Padding(
                padding: _defaultFormPadding,
                child: TextFormField(
                  initialValue: widget.vaultItem?.password,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    icon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      icon: _obscureConfirmPassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                    label: const Text('Confirm Password *'),
                    border: const OutlineInputBorder(),
                  ),
                  validator: _confirmPasswordValidator,
                ),
              ),
              Padding(
                padding: _defaultFormPadding,
                child: TextFormField(
                  initialValue: widget.vaultItem?.username,
                  decoration: const InputDecoration(
                    label: Text('Username / Email *'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _vaultItem.username = value,
                  validator: _mandatoryFieldValidator,
                ),
              ),
              Padding(
                padding: _defaultFormPadding,
                child: TextFormField(
                  initialValue: widget.vaultItem?.websiteName,
                  decoration: const InputDecoration(
                    label: Text('Website Name *'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _vaultItem.websiteName = value,
                  validator: _mandatoryFieldValidator,
                ),
              ),
              Padding(
                padding: _defaultFormPadding,
                child: TextFormField(
                  initialValue: widget.vaultItem?.websiteUrl,
                  decoration: const InputDecoration(
                    label: Text('Website URL'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _vaultItem.websiteUrl = value,
                ),
              ),
              Padding(
                padding: _defaultFormPadding,
                child: ListTile(
                  title: Text(
                    'Category:  ${_vaultItem.category ?? 'none'}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) {
                      return HiveHelper.categories.map((category) {
                        return CheckedPopupMenuItem(
                          value: category,
                          checked: category == _vaultItem.category,
                          child: Text(category),
                        );
                      }).toList();
                    },
                    onSelected: (value) {
                      setState(() {
                        _vaultItem.category =
                            _vaultItem.category != value ? value : null;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
