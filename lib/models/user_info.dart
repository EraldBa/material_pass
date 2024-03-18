import 'package:bcrypt/bcrypt.dart';
import 'package:hive/hive.dart';

part 'user_info.g.dart';

@HiveType(typeId: 0)
final class UserInfo extends HiveObject {
  UserInfo({required String pin, required String extraPassword}) {
    this.pin = pin;
    this.extraPassword = extraPassword;
  }

  UserInfo._fromHive();

  @HiveField(0)
  late String _pin;

  @HiveField(1)
  late String _extraPassword;

  @HiveField(2)
  int pinTries = 3;

  @HiveField(3)
  int extraPasswordTries = 5;

  set pin(String text) {
    _pin = BCrypt.hashpw(text, BCrypt.gensalt());
  }

  set extraPassword(String text) {
    _extraPassword = BCrypt.hashpw(text, BCrypt.gensalt());
  }

  bool matchPin(String otherPin) {
    return BCrypt.checkpw(otherPin, _pin);
  }

  bool matchExtraPassword(String otherPassword) {
    return BCrypt.checkpw(otherPassword, _extraPassword);
  }

  void resetTries() {
    pinTries = 3;
    extraPasswordTries = 5;

    save();
  }
}
