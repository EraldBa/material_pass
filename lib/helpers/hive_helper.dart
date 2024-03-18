import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_pass/models/user_info.dart';
import 'package:material_pass/models/vault_item.dart';

final class HiveHelper {
  HiveHelper._internal();

  static final HiveHelper _instance = HiveHelper._internal();

  static const String _keyName = 'encryptionKey';

  static late final bool userExists;

  late final Box<VaultItem> _vaultItemBox;
  late final Box<String> _categories;
  late final Uint8List _encryptionKey;
  late final UserInfo _userInfo;

  static Future<void> initHive() async {
    await Hive.initFlutter();

    final bool isNotMobile = !Platform.isAndroid && !Platform.isIOS;

    if (isNotMobile) {
      Hive.init(Directory.current.path);
    }

    userExists = await Hive.boxExists('userInfo');

    _registerAdapers();

    await _initKeys();

    await _openBoxes();
  }

  /// throws [Exception] if user already exists
  static Future<void> createUser(UserInfo userInfo) async {
    final userBox = await Hive.openBox<UserInfo>(
      'userInfo',
      encryptionCipher: HiveAesCipher(_instance._encryptionKey),
    );

    if (userBox.isNotEmpty) {
      throw Exception('User already exists');
    }

    _instance._userInfo = userInfo;

    userBox.add(userInfo);
  }

  static Future<void> nukeAll() async {
    await Hive.deleteFromDisk();
  }

  static Future<void> _initKeys() async {
    const secureStorage = FlutterSecureStorage();

    final bool containsKey = await secureStorage.containsKey(key: _keyName);

    if (!containsKey) {
      final List<int> key = Hive.generateSecureKey();

      await secureStorage.write(
        key: _keyName,
        value: base64UrlEncode(key),
      );
    }

    final String? encodedKey = await secureStorage.read(key: _keyName);

    _instance._encryptionKey = base64Url.decode(encodedKey!);
  }

  static Future<void> _openBoxes() async {
    _instance._vaultItemBox = await Hive.openBox<VaultItem>(
      'vaultItems',
      encryptionCipher: HiveAesCipher(_instance._encryptionKey),
    );

    _instance._categories = await Hive.openBox<String>('categories');

    if (userExists) {
      final userBox = await Hive.openBox<UserInfo>(
        'userInfo',
        encryptionCipher: HiveAesCipher(_instance._encryptionKey),
      );

      _instance._userInfo = userBox.values.first;
    }
  }

  static void _registerAdapers() {
    Hive.registerAdapter(UserInfoAdapter());
    Hive.registerAdapter(VaultItemAdapter());
  }

  static HiveHelper get instance => _instance;

  Iterable<VaultItem> get vaultItems => _vaultItemBox.values;

  Iterable<String> get categories => _categories.values;

  Box<String> get categoryBox => _categories;

  Box<VaultItem> get vaultItemBox => _vaultItemBox;

  UserInfo get userInfo => _userInfo;
}
