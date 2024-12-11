// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class APIKeyAdapter extends TypeAdapter<APIKey> {
  @override
  final int typeId = 0;

  @override
  APIKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return APIKey(
      key: fields[0] as String,
      name: fields[1] as String,
      quotaUsed: fields[2] as int,
      lastUsed: fields[3] as DateTime?,
      isActive: fields[4] as bool,
      dailyQuotaLimit: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, APIKey obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.quotaUsed)
      ..writeByte(3)
      ..write(obj.lastUsed)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.dailyQuotaLimit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is APIKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
