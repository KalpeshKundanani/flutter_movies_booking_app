import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_movies_booking_app/utils/app_hive_utils.dart';

part 'genre.g.dart';

@JsonSerializable()
@HiveType(typeId: genreTypeId)
class Genre {
  @JsonKey(name: 'id')
  @HiveField(0)
  final int id;

  @JsonKey(name: 'name')
  @HiveField(1)
  final String name;

  const Genre(this.id, this.name);

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable()
class GenreResult {
  @JsonKey(name: 'genres')
  final List<Genre> genres;

  const GenreResult(this.genres);

  factory GenreResult.fromJson(Map<String, dynamic> json) =>
      _$GenreResultFromJson(json);

  Map<String, dynamic> toJson() => _$GenreResultToJson(this);
}
