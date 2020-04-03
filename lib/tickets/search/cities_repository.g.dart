// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cities_repository.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceAdapter extends TypeAdapter<Place> {
  @override
  final typeId = 2;

  @override
  Place read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Place(
      city: fields[0] as String,
      state: fields[1] as String,
      district: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Place obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.city)
      ..writeByte(1)
      ..write(obj.state)
      ..writeByte(2)
      ..write(obj.district);
  }
}
