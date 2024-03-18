import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

part 'vault_item.g.dart';

@HiveType(typeId: 1)
final class VaultItem extends HiveObject {
  VaultItem({
    required this.password,
    required this.username,
    required this.websiteName,
    this.websiteUrl,
    this.category,
  }) : isPasswordVisible = false;

  @HiveField(0)
  String password;

  @HiveField(1)
  String username;

  @HiveField(2)
  String websiteName;

  @HiveField(3)
  String? websiteUrl;

  @HiveField(4)
  String? category;

  bool isPasswordVisible;

  String get obscuredPassword => '*' * password.length;

  Future<void> copyPasswordToClipboard() async {
    await Clipboard.setData(ClipboardData(text: password));
  }
}
