// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_search_widget.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CinemaAdapter extends TypeAdapter<Cinema> {
  @override
  final typeId = 3;

  @override
  Cinema read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cinema(
      fields[0] as int,
    )
      ..selectedShowTime = fields[1] as String
      ..selectedSeats = (fields[2] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, Cinema obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.selectedShowTime)
      ..writeByte(2)
      ..write(obj.selectedSeats);
  }
}
