// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VaultItemAdapter extends TypeAdapter<VaultItem> {
  @override
  final int typeId = 1;

  @override
  VaultItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VaultItem(
      password: fields[0] as String,
      username: fields[1] as String,
      websiteName: fields[2] as String,
      websiteUrl: fields[3] as String?,
      category: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VaultItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.password)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.websiteName)
      ..writeByte(3)
      ..write(obj.websiteUrl)
      ..writeByte(4)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaultItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
