// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoAdapter extends TypeAdapter<UserInfo> {
  @override
  final int typeId = 0;

  @override
  UserInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfo._fromHive()
      .._pin = fields[0] as String
      .._extraPassword = fields[1] as String
      ..pinTries = fields[2] as int
      ..extraPasswordTries = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, UserInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj._pin)
      ..writeByte(1)
      ..write(obj._extraPassword)
      ..writeByte(2)
      ..write(obj.pinTries)
      ..writeByte(3)
      ..write(obj.extraPasswordTries);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
