import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_pass/models/user_info.dart';
import 'package:material_pass/models/vault_item.dart';

final class HiveHelper {
  HiveHelper._();

  static const _keyName = 'encryptionKey';

  static late final bool _userExists;

  static late final Box<VaultItem> _vaultItemBox;
  static late final Box<String> _categoriesBox;
  static late final Uint8List _encryptionKey;
  static late final UserInfo _userInfo;

  static bool _initComplete = false;

  static Iterable<VaultItem> get vaultItems => _vaultItemBox.values;
  static Iterable<String> get categories => _categoriesBox.values;
  static Box<String> get categoriesBox => _categoriesBox;
  static Box<VaultItem> get vaultItemBox => _vaultItemBox;
  static UserInfo get userInfo => _userInfo;
  static bool get userExists => _userExists;

  /// throws [Exception] if method has already been called
  static Future<void> initHive() async {
    if (_initComplete) {
      throw Exception('initHive method cannot be called more than once');
    }

    await Hive.initFlutter();

    final bool isNotMobile = !Platform.isAndroid && !Platform.isIOS;

    if (isNotMobile) {
      Hive.init(Directory.current.path);
    }

    _userExists = await Hive.boxExists('userInfo');

    _registerAdapers();

    await _initKeys();

    await _openBoxes();

    _initComplete = true;
  }

  /// throws [Exception] if user already exists
  static Future<void> createUser(UserInfo userInfo) async {
    final userBox = await Hive.openBox<UserInfo>(
      'userInfo',
      encryptionCipher: HiveAesCipher(_encryptionKey),
    );

    if (userBox.isNotEmpty) {
      throw Exception('User already exists');
    }

    _userInfo = userInfo;

    userBox.add(userInfo);
  }

  static Future<void> removeCategory(int index, String category) async {
    for (final vaultItem in _vaultItemBox.values) {
      if (vaultItem.category == category) {
        vaultItem.category = null;
        vaultItem.save();
      }
    }

    await _categoriesBox.deleteAt(index);
  }

  static Future<void> nukeAllData() async {
    await Hive.deleteFromDisk();
  }

  static Future<void> _initKeys() async {
    const secureStorage = FlutterSecureStorage();

    if (!await secureStorage.containsKey(key: _keyName)) {
      final List<int> key = Hive.generateSecureKey();

      await secureStorage.write(
        key: _keyName,
        value: base64UrlEncode(key),
      );
    }

    final String? encodedKey = await secureStorage.read(key: _keyName);

    _encryptionKey = base64Url.decode(encodedKey!);
  }

  static Future<void> _openBoxes() async {
    _vaultItemBox = await Hive.openBox<VaultItem>(
      'vaultItems',
      encryptionCipher: HiveAesCipher(_encryptionKey),
    );

    _categoriesBox = await Hive.openBox<String>('categories');

    if (_userExists) {
      final userBox = await Hive.openBox<UserInfo>(
        'userInfo',
        encryptionCipher: HiveAesCipher(_encryptionKey),
      );

      _userInfo = userBox.values.first;
    }
  }

  static void _registerAdapers() {
    Hive.registerAdapter(UserInfoAdapter());
    Hive.registerAdapter(VaultItemAdapter());
  }
}
