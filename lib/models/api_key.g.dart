part of 'api_key.dart';

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
      id: fields[0] as String,
      name: fields[1] as String,
      isActive: fields[2] as bool,
      quotaUsed: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, APIKey obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.quotaUsed);
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
