// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final typeId = 0;

  @override
  Movie read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as DateTime,
      fields[4] as bool,
      (fields[5] as List)?.cast<int>(),
      fields[6] as String,
      fields[7] as double,
      fields[8] as String,
    )
      ..place = fields[9] as Place
      ..cinema = fields[10] as Cinema;
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.posterURL)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.releaseDate)
      ..writeByte(4)
      ..write(obj.isAdult)
      ..writeByte(5)
      ..write(obj.genreIds)
      ..writeByte(6)
      ..write(obj.overview)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.language)
      ..writeByte(9)
      ..write(obj.place)
      ..writeByte(10)
      ..write(obj.cinema);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    json['id'] as int,
    json['poster_path'] as String,
    json['title'] as String,
    json['release_date'] == null
        ? null
        : DateTime.parse(json['release_date'] as String),
    json['adult'] as bool,
    (json['genre_ids'] as List)?.map((e) => e as int)?.toList(),
    json['overview'] as String,
    (json['vote_average'] as num)?.toDouble(),
    json['original_language'] as String,
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'poster_path': instance.posterURL,
      'title': instance.title,
      'release_date': instance.releaseDate?.toIso8601String(),
      'adult': instance.isAdult,
      'genre_ids': instance.genreIds,
      'overview': instance.overview,
      'vote_average': instance.rating,
      'original_language': instance.language,
    };
